import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/Controllers/all_posts_controller.dart';
import '../../Models/post.dart';

class PostDetailView extends StatefulWidget {
  final Post post;
  final List<Post> latestThree; // ✅ Pass latest three posts
final String tag;
  const PostDetailView({
    super.key,
    required this.post,
    required this.latestThree,
    required this.tag
  });

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  late Post currentPost;
  List<Post> relatedPosts = [];
  late final AllPostsController allPostController;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _headingKeys = {};
  List<String> _headings = [];

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;
    _headings = extractHeadings(currentPost.content);
allPostController = Get.find<AllPostsController>(tag: widget.tag);
    _loadRelated(); // fetch related once at start
  }

  void _loadPost(Post post) {
    setState(() {
      currentPost = post;
      _headings = extractHeadings(currentPost.content);
      _headingKeys.clear();
      _scrollController.jumpTo(0);
    });

    _loadRelated(); // refresh related
  }

  Future<void> _loadRelated() async {
    final related = await allPostController.getRelatedPosts(currentPost);
    setState(() {
      relatedPosts = related;
    });
  }



  String _formatDate(String raw) {
    try {
      final dt = DateTime.tryParse(raw) ??
          DateTime.tryParse(raw.replaceFirst(' ', 'T'));
      if (dt != null) {
        return DateFormat('MMMM d, yyyy').format(dt);
      }
    } catch (_) {}
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Details")),
      body: Column(
        children: [
          // ✅ Table of Contents (if headings exist)
          if (_headings.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "Table of Contents",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _headings.map((title) {
                  return DropdownMenuItem(
                    value: title,
                    child: Text(title,
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith()),
                  );
                }).toList(),
                onChanged: (selected) {
                  if (selected != null) {
                    final key = _headingKeys[selected];
                    if (key != null && key.currentContext != null) {
                      Scrollable.ensureVisible(
                        key.currentContext!,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
              ),
            ),

          // ✅ Post content + Latest Blogs
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Post image
                  if (currentPost.imageUrl != null &&
                      currentPost.imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        currentPost.imageUrl!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 12),

                  // 🔹 Categories
                  Wrap(
                    spacing: 4,
                    children: currentPost.categories
                        .skip(1)
                        .map((cat) =>
                        //  Chip(
                        //       label:
                        HtmlWidget(

                               '$cat ,',
                                  textStyle: const TextStyle(
                                      color: blackColor, fontSize: 11),),
                             // backgroundColor: Colors.black87,
                            )
                           // )
                        .toList(),
                  ),
                  const SizedBox(height: 8),

                  // 🔹 Title
                  Text(currentPost.title,
                      style:Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),

                  // 🔹 Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(currentPost.date),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Content
                  HtmlWidget(
                    currentPost.content,
                      
                    customWidgetBuilder: (element) {
                      if (element.localName == 'h2') {
                        final text = element.text.trim();
                        final key = GlobalKey();
                        _headingKeys[text] = key;
                        return Container(
                          key: key,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            text,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return null;
                    },
                  ),




SizedBox(height: 30,),
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: disclaimerColor,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: "Disclaimer: ",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
        ),
        TextSpan(
          text:
              "Readers are advised that the material contained herein is solely for information purposes. Readers are encouraged to conduct their own research and due diligence, and/or obtain professional advice. Nothing contained herein constitutes a representation by the publisher, nor a solicitation for the purchase or sale of securities. The information contained herein is based on sources which the publisher believes to be reliable, but is not guaranteed to be accurate, and does not purport to be a complete statement or summary of the available data. Any opinions expressed are subject to change without notice. While the information herein is believed to be accurate and reliable it is not guaranteed or implied to be so. The information herein may not be complete or correct; it is provided in good faith but without any legal responsibility or obligation to provide future updates.",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 11,
              ),
        ),
      ],
    ),
  ),
)


                  ,const SizedBox(height: 30),

                  // 🔹 Latest Blogs section
                  if (widget.latestThree.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Latest Blogs",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: widget.latestThree.map((post) {
                            return GestureDetector(
                              onTap: () => _loadPost(post),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    // Image
                                    if (post.imageUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          post.imageUrl!,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    const SizedBox(width: 12),

                                    // Title + Date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(post.date),
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ],


               // related Articles
               if (relatedPosts.isNotEmpty) ...[
  const SizedBox(height: 30),
  Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.red.shade600,

      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Related Articles",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: relatedPosts
          //.where((p) => p.id != currentPost.id)
          .map((post) {
            return GestureDetector(
              onTap: () => _loadPost(post), // reload in same screen
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    if (post.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          post.imageUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(post.date),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        )
      ],
    ),
  )
],

               
                ],
              ),
            ),
          ),
       
       
       
        ],
      ),
    );
  }
}

/// ✅ Extract all <h2> tags from HTML
List<String> extractHeadings(String htmlContent) {
  final doc = html_parser.parse(htmlContent);
  final h2Tags = doc.getElementsByTagName('h2');
  return h2Tags.map((e) => e.text.trim()).toList();
}
