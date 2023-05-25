import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/story.dart';
import 'image_from_network.dart';
import 'custom_card.dart';

class StoryCard extends StatelessWidget {
  /// Create [Card] that will display the basic info of the [story]
  /// provided.
  ///
  /// Suitable for use on [GridView] with 3 / 4 aspect ratio.
  const StoryCard(
    this.story, {
    super.key,
    this.onTap,
  });

  final Story story;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final name = story.name;
    // TODO: "MMMd" format
    final createdAt = '${story.createdAt.month}/${story.createdAt.day}';
    final description = story.description;

    return CustomCard(
      onTap: onTap,
      child: LayoutBuilder(builder: (context, constraint) {
        final maxWidth = constraint.maxWidth;

        return SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ImageFromNetwork(
                  imageUrl: story.photoUrl,
                  width: maxWidth,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 20.0,
                              child: Text(
                                name[0].toUpperCase(),
                                style: textTheme.headlineSmall,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            flex: 3,
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            flex: 2,
                            child: Opacity(
                              opacity: 0.5,
                              child: Text(
                                createdAt,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
