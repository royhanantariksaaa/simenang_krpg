import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:simenang_krpg/components/cards/krpg_card.dart';
import 'package:simenang_krpg/design_system/krpg_design_system.dart';
import 'package:simenang_krpg/models/location_model.dart';

/// LocationCard with FlutterMap integration
/// 
/// Available map styles:
/// - 'voyager' (DEFAULT) - Modern, colorful CartoDB Voyager ⭐
/// - 'light' - Minimal light CartoDB style
/// - 'dark' - Dark theme CartoDB style  
/// - 'topo' - OpenTopoMap with elevation colors (colorful)
/// - 'satellite' - Esri satellite imagery
/// - 'osm' - Standard OpenStreetMap
/// 
/// Note: Some styles like 'terrain' and 'watercolor' require API keys
/// and may not work without proper authentication.
class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback? onTap;
  final String? mapStyle;

  const LocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.mapStyle,
  });

  String get _getTileUrl {
    switch (mapStyle) {
      case 'light':
        return 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
      case 'dark':
        return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
      case 'voyager':
        return 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
      case 'terrain':
        return 'https://tiles.stadiamaps.com/tiles/stamen_terrain/{z}/{x}/{y}.png';
      case 'watercolor':
        return 'https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.png';
      case 'satellite':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'osm':
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case 'osm_hot':
        return 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';
      case 'topo':
        return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
      default:
        return 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';
    }
  }

  List<String> get _getSubdomains {
    switch (mapStyle) {
      case 'satellite':
        return [];
      case 'terrain':
      case 'watercolor':
        return [];
      default:
        return ['a', 'b', 'c', 'd'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCoordinates = location.latitude != null && location.longitude != null;

    return KRPGCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasCoordinates)
            _buildMap(),
          Padding(
            padding: EdgeInsets.only(
              top: hasCoordinates ? KRPGTheme.spacingSm : 0,
              left: KRPGTheme.spacingMd,
              right: KRPGTheme.spacingMd,
              bottom: KRPGTheme.spacingMd,
            ),
            child: _buildInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(KRPGTheme.radiusMd),
          topRight: Radius.circular(KRPGTheme.radiusMd),
        ),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(location.latitude!, location.longitude!),
            initialZoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: _getTileUrl,
              subdomains: _getSubdomains,
              userAgentPackageName: 'com.example.simenang_krpg',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(location.latitude!, location.longitude!),
                  width: 80,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      color: KRPGTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      KRPGIcons.location,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location.name,
          style: KRPGTextStyles.cardTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        KRPGSpacing.verticalXXS,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(KRPGIcons.location, size: 16, color: KRPGTheme.neutralMedium),
            KRPGSpacing.horizontalXS,
            Expanded(
              child: Text(
                location.address,
                style: KRPGTextStyles.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (location.description != null && location.description!.isNotEmpty) ...[
          KRPGSpacing.verticalXS,
          Text(
            location.description!,
            style: KRPGTextStyles.bodyMediumSecondary.copyWith(fontStyle: FontStyle.italic),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
} 