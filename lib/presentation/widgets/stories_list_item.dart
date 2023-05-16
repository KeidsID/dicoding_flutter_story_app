import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:dicoding_flutter_story_app/utils/custom_text_overflow.dart';
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
    final textTheme = context.textTheme;
    final createdAt = story.createdAt;

    final titleMedium = textTheme.titleMedium;
    final dateTimeTextTheme = titleMedium?.copyWith(
      color: titleMedium.color?.withOpacity(0.5),
    );

    return Material(
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraint) {
            final maxWidth = constraint.maxWidth;
            final maxHeight = constraint.maxHeight;

            return SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: CachedNetworkImage(
                      imageUrl: story.photoUrl,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      width: maxWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: customTextOverflow(
                                    story.name,
                                    maxLength: 12,
                                  ),
                                  style: textTheme.titleLarge,
                                ),
                                const WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: SizedBox(width: 8.0),
                                ),
                                TextSpan(
                                  // TODO: Localizations it with 'MMMd' format
                                  text: '${createdAt.month}/${createdAt.day}',
                                  style: dateTimeTextTheme,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            story.description,
                            maxLines: 2,
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