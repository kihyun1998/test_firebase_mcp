import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late NaverMapController _mapController;
  final List<NMarker> _markers = [];

  // 초기 위치 (서울 시청)
  static const _initialPosition = NLatLng(37.5666, 126.9780);

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  // 초기 마커 설정
  void _initializeMarkers() {
    _markers.addAll([
      NMarker(
        id: 'seoul',
        position: const NLatLng(37.5666, 126.9780),
        caption: const NOverlayCaption(text: '서울시청'),
      ),
      NMarker(
        id: 'gangnam',
        position: const NLatLng(37.5547, 126.9707),
        caption: const NOverlayCaption(text: '강남역'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('네이버 지도'),
        actions: [
          // 서울로 이동
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              _moveTo(_initialPosition, zoom: 13.0);
            },
          ),
          // 현재 위치로 이동
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              // TODO: 실제 위치 권한 및 GPS 연동 필요
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('현재 위치 기능은 GPS 연동이 필요합니다')),
              );
            },
          ),
        ],
      ),
      body: NaverMap(
        options: const NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: _initialPosition,
            zoom: 13.0,
          ),
          minZoom: 5.0,
          maxZoom: 18.0,
          extent: NLatLngBounds(
            southWest: NLatLng(31.43, 122.37),
            northEast: NLatLng(44.35, 132.0),
          ),
          // 로고 및 컨트롤 설정
          logoAlign: NLogoAlign.leftBottom,
          indoorEnable: true,
          locationButtonEnable: false,
          consumeSymbolTapEvents: false,
        ),
        // 지도 클릭 이벤트
        onMapTapped: (point, latLng) {
          _addMarker(latLng);
        },
        onMapReady: (controller) async {
          _mapController = controller;
          debugPrint('네이버 지도 로드 완료');

          // 초기 마커 추가
          for (final marker in _markers) {
            await _mapController.addOverlay(marker);
          }
        },
      ),
      // 줌 컨트롤 버튼
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            mini: true,
            onPressed: _zoomIn,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            onPressed: _zoomOut,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  // 카메라 이동
  void _moveTo(NLatLng position, {double? zoom}) {
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
      target: position,
      zoom: zoom,
    );
    _mapController.updateCamera(cameraUpdate);
  }

  // 줌 인
  void _zoomIn() {
    _mapController.updateCamera(NCameraUpdate.zoomIn());
  }

  // 줌 아웃
  void _zoomOut() {
    _mapController.updateCamera(NCameraUpdate.zoomOut());
  }

  // 마커 추가
  void _addMarker(NLatLng position) async {
    final markerId = 'marker_${DateTime.now().millisecondsSinceEpoch}';
    final marker = NMarker(
      id: markerId,
      position: position,
      caption: const NOverlayCaption(
        text: '새 마커',
        color: Colors.white,
        textSize: 12,
      ),
    );

    setState(() {
      _markers.add(marker);
    });

    await _mapController.addOverlay(marker);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '마커 추가됨: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
