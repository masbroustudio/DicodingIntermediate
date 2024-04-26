import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListStoryLoading extends StatelessWidget {
  const ListStoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => _buildStoryItem(),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }

  Widget _buildStoryItem() {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26),
          BoxShadow(color: Colors.black26),
          BoxShadow(color: Colors.black26),
          BoxShadow(color: Colors.black26),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildShimmerContainer(height: 150),
          const SizedBox(height: 10),
          _buildShimmerContainer(height: 14),
          const SizedBox(height: 4),
          _buildShimmerContainer(height: 16),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({required double height}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
