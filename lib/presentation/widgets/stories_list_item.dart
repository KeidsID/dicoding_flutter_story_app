import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/story.dart';

class StoriesListItem extends StatelessWidget {
  /// Create a [Widget] that will display the basic info of the [story]
  /// provided.
  ///
  /// Suitable for use on [GridView].
  const StoriesListItem(
    this.story, {
    Key? key,
    this.onTap,
  }) : super(key: key);

  /// Story info to display on the widget.
  final Story story;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    final name = story.name;
    // TODO: "MMMd" format
    final createdAt = '${story.createdAt.month}/${story.createdAt.day}';
    final description = story.description;

    final widgetBorderRadius = BorderRadius.circular(16.0);

    return Material(
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraint) {
            final maxWidth = constraint.maxWidth;
            final maxHeight = constraint.maxHeight;

            return Container(
              width: maxWidth,
              height: maxHeight,
              decoration: BoxDecoration(
                color: colorScheme.onBackground.withOpacity(0.05),
                borderRadius: widgetBorderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: widgetBorderRadius,
                      child: CachedNetworkImage(
                        imageUrl: story.photoUrl,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        width: maxWidth,
                        fit: BoxFit.cover,
                      ),
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
          },
        ),
      ),
    );
  }
}
