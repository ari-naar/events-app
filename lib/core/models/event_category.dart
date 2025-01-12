import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

enum EventCategory {
  social(
    label: 'Social',
    icon: HugeIcons.strokeRoundedUserGroup,
    image:
        'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?q=80&w=2000',
    color: Color(0xFF6C5CE7),
  ),
  sports(
    label: 'Sports',
    icon: HugeIcons.strokeRoundedFootballPitch,
    image:
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?q=80&w=2000',
    color: Color(0xFF00B894),
  ),
  education(
    label: 'Education',
    icon: HugeIcons.strokeRoundedBookOpen02,
    image:
        'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=2000',
    color: Color(0xFFFD9644),
  ),
  entertainment(
    label: 'Entertainment',
    icon: HugeIcons.strokeRoundedFlimSlate,
    image:
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=2000',
    color: Color(0xFFFF6B6B),
  ),
  food(
    label: 'Food & Drinks',
    icon: HugeIcons.strokeRoundedRestaurant02,
    image:
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=2000',
    color: Color(0xFFFF7675),
  ),
  outdoors(
    label: 'Outdoors',
    icon: Icons.landscape,
    image:
        'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=2000',
    color: Color(0xFF26DE81),
  ),
  networking(
    label: 'Networking',
    icon: Icons.business,
    image:
        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=2000',
    color: Color(0xFF4834D4),
  ),
  other(
    label: 'Other',
    icon: Icons.category,
    image:
        'https://images.unsplash.com/photo-1496449903678-68ddcb189a24?q=80&w=2000',
    color: Color(0xFF95A5A6),
  );

  final String label;
  final IconData icon;
  final String image;
  final Color color;

  const EventCategory({
    required this.label,
    required this.icon,
    required this.image,
    required this.color,
  });
}
