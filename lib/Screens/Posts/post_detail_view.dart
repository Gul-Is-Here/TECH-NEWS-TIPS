import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:tnt/Config/app_config.dart';
import 'package:tnt/Globle/colors.dart';
import 'package:tnt/Controllers/all_posts_controller.dart';
import 'package:tnt/Models/comment.dart';
import 'package:tnt/Services/comment_service.dart';
import '../../Models/post.dart';

class PostDetailView extends StatefulWidget {
  final Post post;
  final List<Post> latestThree;
  final String tag;

  const PostDetailView({
    super.key,
    required this.post,
    required this.latestThree,
    required this.tag,
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

  // ── Comment state ──────────────────────────────────────────────────────────
  List<Comment> _comments = [];
  bool _commentsLoading = false;
  String _commentsError = '';
  late final TextEditingController _commentInput;

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;
    _headings = extractHeadings(currentPost.content);
    _commentInput = TextEditingController();
    allPostController = Get.find<AllPostsController>(tag: widget.tag);
    _loadRelated();
    _fetchComments();
  }

  @override
  void dispose() {
    _commentInput.dispose();
    super.dispose();
  }

  // ── Navigation helpers ─────────────────────────────────────────────────────

  void _loadPost(Post post) {
    setState(() {
      currentPost = post;
      _headings = extractHeadings(currentPost.content);
      _headingKeys.clear();
      _scrollController.jumpTo(0);
      _comments = [];
      _commentsError = '';
    });
    _loadRelated();
    _fetchComments();
  }

  Future<void> _loadRelated() async {
    final related = await allPostController.getRelatedPosts(currentPost);
    setState(() => relatedPosts = related);
  }

  // ── Comments ───────────────────────────────────────────────────────────────

  Future<void> _fetchComments() async {
    setState(() => _commentsLoading = true);
    try {
      final result = await CommentService.fetchComments(currentPost.id);
      setState(() {
        _comments = result;
        _commentsError = '';
      });
    } catch (_) {
      setState(() => _commentsError = 'Failed to load comments');
    } finally {
      setState(() => _commentsLoading = false);
    }
  }

  void _showEditSheet(Comment comment) {
    final editCtrl = TextEditingController(text: comment.content);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_outlined, size: 18, color: blueColor),
                const SizedBox(width: 8),
                Text(
                  'Edit Comment',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: editCtrl,
              maxLines: 4,
              autofocus: true,
              style: Theme.of(ctx).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Edit your comment…',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: blueColor, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // TODO: await CommentService.editComment(commentId: comment.id, content: editCtrl.text.trim());
                    Get.snackbar(
                      'Coming Soon',
                      'Edit comment API will be connected soon',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                    );
                  },
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ── Date formatter ─────────────────────────────────────────────────────────

  String _formatDate(String raw) {
    try {
      final dt = DateTime.tryParse(raw) ??
          DateTime.tryParse(raw.replaceFirst(' ', 'T'));
      if (dt != null) return DateFormat('MMMM d, yyyy').format(dt);
    } catch (_) {}
    return raw;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: Column(
        children: [
          // Table of contents
          if (_headings.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Table of Contents',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                ),
                items: _headings.map((title) {
                  return DropdownMenuItem(
                    value: title,
                    child: Text(title,
                        style: Theme.of(context).textTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (selected) {
                  if (selected != null) {
                    final key = _headingKeys[selected];
                    if (key?.currentContext != null) {
                      Scrollable.ensureVisible(
                        key!.currentContext!,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
              ),
            ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured image
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

                  // Categories
                  Wrap(
                    spacing: 4,
                    children: currentPost.categories
                        .skip(1)
                        .map((cat) => HtmlWidget(
                              '$cat ,',
                              textStyle: const TextStyle(
                                  color: blackColor, fontSize: 11),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(currentPost.title,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(currentPost.date),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // HTML content
                  HtmlWidget(
                    currentPost.content,
                    customWidgetBuilder: (element) {
                      if (element.localName == 'h2') {
                        final text = element.text.trim();
                        final key = GlobalKey();
                        _headingKeys[text] = key;
                        return Container(
                          key: key,
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            text,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: disclaimerColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Disclaimer: ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Readers are advised that the material contained herein is solely for information purposes. Readers are encouraged to conduct their own research and due diligence, and/or obtain professional advice. Nothing contained herein constitutes a representation by the publisher, nor a solicitation for the purchase or sale of securities. The information contained herein is based on sources which the publisher believes to be reliable, but is not guaranteed to be accurate, and does not purport to be a complete statement or summary of the available data. Any opinions expressed are subject to change without notice. While the information herein is believed to be accurate and reliable it is not guaranteed or implied to be so. The information herein may not be complete or correct; it is provided in good faith but without any legal responsibility or obligation to provide future updates.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Latest Blogs
                  if (widget.latestThree.isNotEmpty)
                    _buildPostsBlock(
                      context,
                      title: 'Latest Blogs',
                      color: Colors.blue.shade700,
                      posts: widget.latestThree,
                    ),

                  // Related Articles
                  if (relatedPosts.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    _buildPostsBlock(
                      context,
                      title: 'Related Articles',
                      color: Colors.red.shade600,
                      posts: relatedPosts,
                    ),
                  ],

                  // ── Comments section ──────────────────────────────────────
                  const SizedBox(height: 30),
                  _buildCommentsSection(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Sticky Add Comment bar ────────────────────────────────────────
          _buildCommentInput(context),
        ],
      ),
    );
  }

  // ── Comments section ───────────────────────────────────────────────────────

  Widget _buildCommentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Row(
          children: [
            Text(
              _comments.isNotEmpty
                  ? '${_comments.length} Comment${_comments.length == 1 ? '' : 's'}'
                  : 'Comments',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: lightBlackColor,
                  ),
            ),
            const Spacer(),
            if (!_commentsLoading)
              GestureDetector(
                onTap: _fetchComments,
                child: Icon(Icons.refresh, size: 16, color: Colors.grey.shade400),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(color: Colors.grey.shade200, height: 1),
        const SizedBox(height: 14),

        // ── States ───────────────────────────────────────────────────────────
        if (_commentsLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: CircularProgressIndicator(strokeWidth: 2, color: blueColor),
            ),
          )
        else if (_commentsError.isNotEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.wifi_off_outlined,
                      size: 36, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text(
                    _commentsError,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  TextButton.icon(
                    onPressed: _fetchComments,
                    icon: const Icon(Icons.refresh, size: 14),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if (_comments.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 36, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  Text(
                    'No comments yet — be the first!',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: _comments
                .map((c) => _buildCommentCard(context, c))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCommentCard(BuildContext context, Comment comment) {
    final initial =
        comment.author.isNotEmpty ? comment.author[0].toUpperCase() : '?';
    final isOwn = comment.userId == AppSession.userId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar ──────────────────────────────────────────────────────
          CircleAvatar(
            radius: 18,
            backgroundColor: _avatarColor(comment.author),
            child: Text(
              initial,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),

          // ── Bubble + actions ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bubble
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author + overflow menu
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.author,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(comment.date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (isOwn)
                            GestureDetector(
                              onTap: () => _showEditSheet(comment),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(Icons.more_horiz,
                                    size: 18, color: Colors.grey.shade500),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Comment text
                      Text(
                        comment.content,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black87,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),

                // ── Action row ─────────────────────────────────────────────
                const SizedBox(height: 6),
                Row(
                  children: [
                    _CommentAction(
                      icon: Icons.thumb_up_outlined,
                      label: 'Like',
                      onTap: () => Get.snackbar(
                        'Coming Soon',
                        'Like feature will be connected soon',
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 2),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text('·',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 12)),
                    const SizedBox(width: 2),
                    _CommentAction(
                      icon: Icons.reply_outlined,
                      label: 'Reply',
                      onTap: () => Get.snackbar(
                        'Coming Soon',
                        'Reply feature will be connected soon',
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Comment input bar (sticky — LinkedIn style) ───────────────────────────

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // User avatar
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: blueColor.withValues(alpha: 0.12),
              child: const Icon(Icons.person, size: 18, color: blueColor),
            ),
          ),
          const SizedBox(width: 10),

          // Input pill — send arrow lives inside
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 110),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentInput,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'Add a comment…',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _submitComment,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: blueColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment() {
    final text = _commentInput.text.trim();
    if (text.isEmpty) return;
    // TODO: await CommentService.addComment(postId: currentPost.id, userId: AppSession.userId!, content: text);
    _commentInput.clear();
    FocusScope.of(context).unfocus();
    Get.snackbar(
      'Coming Soon',
      'Add comment API will be connected soon',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  // ── Shared latest/related block ────────────────────────────────────────────

  Widget _buildPostsBlock(
    BuildContext context, {
    required String title,
    required Color color,
    required List<Post> posts,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: posts.map((post) {
              return GestureDetector(
                onTap: () => _loadPost(post),
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
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Avatar color helper ────────────────────────────────────────────────────

  static const List<Color> _avatarColors = [
    blueColor,
    greenColor,
    purpleColor,
    Color(0xFFE91E63),
    Color(0xFFFF9800),
    Color(0xFF009688),
  ];

  Color _avatarColor(String author) {
    if (author.isEmpty) return _avatarColors[0];
    return _avatarColors[author.codeUnitAt(0) % _avatarColors.length];
  }
}

/// Extract all h2 headings from HTML content.
List<String> extractHeadings(String htmlContent) {
  final doc = html_parser.parse(htmlContent);
  return doc
      .getElementsByTagName('h2')
      .map((e) => e.text.trim())
      .toList();
}

// ── Reusable Like / Reply action button ───────────────────────────────────────

class _CommentAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CommentAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 13, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
