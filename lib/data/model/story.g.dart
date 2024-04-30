// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      photoUrl: json['photoUrl'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'lat': instance.lat,
      'lon': instance.lon,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
