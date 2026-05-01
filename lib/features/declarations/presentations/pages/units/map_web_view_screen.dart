import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/services/loading.dart';
import '../../../data/models/map_location_result.dart';

class MapWebViewScreen extends StatefulWidget {
  const MapWebViewScreen({super.key, required this.urban, this.suffix});

  final int urban;
  final String? suffix;

  @override
  State<MapWebViewScreen> createState() => _MapWebViewScreenState();
}

class _MapWebViewScreenState extends State<MapWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  bool _jsInjected = false;
  String _token = '';
  MapLocationResult? _lastResult;
  final loadingService = LoadingService();

  static final String _fixedMapUrl = '${ApiConstants.baseEnvUrl}/iframe-map';
  static String _mapUrl = '${ApiConstants.baseEnvUrl}/iframe-map';

  @override
  void initState() {
    super.initState();
    if (widget.suffix != null) {
      _mapUrl = '$_fixedMapUrl${widget.suffix}';
    } else {
      _mapUrl = '$_fixedMapUrl?urban=${widget.urban}';
    }
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await DioClient.getToken();
    setState(() => _token = token ?? '');
  }

  void _handleMapResponse(dynamic data) {
    try {
      final emcMapOutput = data['Message']['Data']['emcMapOutput'];

      final featureDataRaw = emcMapOutput['featureData'];
      final featureData = featureDataRaw is String
          ? jsonDecode(featureDataRaw)
          : featureDataRaw;

      if (featureData == null) return;

      final addressRaw = featureData['address'];

      final address = addressRaw is String
          ? jsonDecode(addressRaw)
          : addressRaw;

      final geometryRaw = featureData['geometry'];
      final geometry = geometryRaw is String
          ? jsonDecode(geometryRaw)
          : geometryRaw;

      final result = MapLocationResult(
        renin: featureData['renin'],
        buildingName: featureData['name'],
        buildingType: featureData['type'],
        areaMq: featureData['area_m2']?.toDouble(),
        geometry: geometry,

        // names
        governorate: _extractName(address?['goveronrate']),
        policeStation: _extractName(address?['policestation']),
        neighborhood: _extractName(address?['neighborhood']),
        street: address?['street'],
        region: _extractName(address?['region']),
        city: _extractName(address?['city']),
        mogawra: _extractName(address?['mogawra']),
        village: _extractName(address?['village']),
        settlement: _extractName(address?['settlement']),
        streetNumber: address?['number'],

        regionId: _extractId(address?['region']),
        governorateId: _extractId(address?['goveronrate']),
        cityId: _extractId(address?['city']),
        policeStationId: _extractId(address?['policestation']),
        neighborhoodId: _extractId(address?['neighborhood']),
        mogawraId: _extractId(address?['mogawra']),
        villageId: _extractId(address?['village']),
        settlementId: _extractId(address?['settlement']),
      );

      setState(() => _lastResult = result);
    } catch (error) {
      debugPrint('Parse error: $error');
    }
  }

  String? _extractName(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str == '|') return null;
    return str.contains('|') ? str.split('|').first.trim() : str;
  }

  String? _extractId(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str == '|') return null;
    if (!str.contains('|')) return null;
    final id = str.split('|').last.trim();
    return id.isEmpty ? null : id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديد العقار من الخريطة'),
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('لاغي', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_lastResult != null) {
                Navigator.pop(context, _lastResult);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('برجاء تحديد موقع أولاً')),
                );
              }
            },
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _token.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(_mapUrl),
                    headers: {
                      'Authorization': 'Bearer $_token',
                      'Accept': 'application/json',
                    },
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    domStorageEnabled: true,
                    useShouldInterceptRequest: true,
                    useShouldInterceptAjaxRequest: true,
                    useShouldInterceptFetchRequest: true,
                    cacheEnabled: false,
                    clearCache: true,
                    mixedContentMode:
                        MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    loadingService.showLoading(context);
                    setState(() => _isLoading = true);
                  },
                  onLoadStop: (controller, url) async {
                    await loadingService.hideLoading(context);
                    setState(() => _isLoading = false);
                    if (_token.isEmpty) return;
                    if (_jsInjected) return;
                    _jsInjected = true;

                    await controller.evaluateJavascript(
                      source:
                          '''
                      (function() {
                        const token = "$_token";

                        const originalFetch = window.fetch;
                        window.fetch = function(url, options = {}) {
                          options.headers = options.headers || {};
                          options.headers['Authorization'] = 'Bearer ' + token;
                          return originalFetch(url, options).then(res => {
                            if (url.includes('getEMCMapData')) {
                              res.clone().json().then(data => {
                                console.log('MAP_DATA:' + JSON.stringify(data));
                              });
                            }
                            return res;
                          });
                        };

                        const originalOpen = XMLHttpRequest.prototype.open;
                        const originalSend = XMLHttpRequest.prototype.send;

                        XMLHttpRequest.prototype.open = function(method, url, ...args) {
                          this._url = url;
                          return originalOpen.apply(this, [method, url, ...args]);
                        };

                        XMLHttpRequest.prototype.send = function(...args) {
                          this.setRequestHeader('Authorization', 'Bearer ' + token);
                          this.addEventListener('load', function() {
                            if (this._url && this._url.includes('getEMCMapData')) {
                              console.log('MAP_DATA:' + this.responseText);
                              console.log('MAP_LOADING:end'); 
                            }
                          });
                          
                          if (this._url && this._url.includes('getEMCMapData')) {
                            console.log('MAP_LOADING:start');
                          }
                          return originalSend.apply(this, args);
                        };
                      })();
                    ''',
                    );
                  },

                  shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
                    final url = ajaxRequest.url.toString();
                    if (url.contains('getEMCMapData')) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          setState(() => _isLoading = true);
                          loadingService.showLoading(context);
                        }
                      });
                    }
                    return ajaxRequest;
                  },

                  shouldInterceptFetchRequest:
                      (controller, fetchRequest) async {
                        final url = fetchRequest.url.toString();
                        if (url.contains('getEMCMapData')) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              setState(() => _isLoading = true);
                              loadingService.showLoading(context);
                            }
                          });
                        }
                        return fetchRequest;
                      },

                  onConsoleMessage: (controller, consoleMessage) async {
                    final msg = consoleMessage.message;
                    if (msg == 'MAP_LOADING:start') {
                      setState(() => _isLoading = true);
                      if (context.mounted) loadingService.showLoading(context);
                      return;
                    }

                    if (msg == 'MAP_LOADING:end') {
                      setState(() {
                        _isLoading = false;
                      });
                      if (context.mounted) {
                        await loadingService.hideLoading(context);
                      }
                      return;
                    }

                    if (msg.startsWith('EMC:MapFunction:ZoomToLayer:Success') ||
                        msg.startsWith(
                          'EMC:MapFunction:ZoomToFeature:Success',
                        )) {
                      if (context.mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                        await loadingService.hideLoading(context);
                      }
                    }

                    // Data handling
                    if (msg.startsWith('MAP_DATA:')) {
                      if (context.mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                        await loadingService.hideLoading(context);
                      }
                      final jsonStr = msg.replaceFirst('MAP_DATA:', '');
                      try {
                        final data = jsonDecode(jsonStr);
                        _handleMapResponse(data);
                        _webViewController!.webStorage.sessionStorage.controller
                            ?.clearAllCache();
                      } catch (e) {
                        debugPrint('JSON parse error: $e');
                      }
                    }
                  },
                  onReceivedError: (controller, request, error) {
                    debugPrint(
                      'Load Error: ${error.type} - ${error.description}',
                    );
                  },
                ),
                // if (_isLoading)
                //   SizedBox(
                //     width: double.infinity,
                //     height: MediaQuery.of(context).size.height,
                //     child: const Center(
                //       child: CircularProgressIndicator.adaptive(),
                //     ),
                //   ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _webViewController?.clearCache();
    _webViewController = null;
    super.dispose();
  }
}
