import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/awareness_data.dart';
import '../localization/app_translations.dart';
import '../models/awareness_article.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar_language_switch.dart';

/// Screen 7: Health & Awareness Screen (“وعي وصحة / Health & Awareness”)
/// Provides verified, reassuring educational articles on breast health,
/// early screening, healthy lifestyle, emotional wellbeing, and appointment preparation.
/// Includes offline bundled content, official references (WHO, NHS, NCI),
/// and an explicit educational disclaimer.
class HealthAwarenessScreen extends StatefulWidget {
  const HealthAwarenessScreen({super.key});

  @override
  State<HealthAwarenessScreen> createState() => _HealthAwarenessScreenState();
}

class _HealthAwarenessScreenState extends State<HealthAwarenessScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Launches the official verified source URL or gracefully copies it to clipboard
  Future<void> _openSourceUrl(
      BuildContext context, String url, bool isArabic) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        await _copyUrlFallback(context, url, isArabic);
      }
    } catch (_) {
      if (context.mounted) {
        await _copyUrlFallback(context, url, isArabic);
      }
    }
  }

  Future<void> _copyUrlFallback(
      BuildContext context, String url, bool isArabic) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppTranslations.tr('couldNotOpenLinkMessage', isArabic),
            style: GoogleFonts.elMessiri(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.primaryPurple,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final isArabic = appState.isArabic;

    // Filter articles based on search query and category
    final filteredArticles = mockAwarenessArticles.where((article) {
      final title = article.getTitle(isArabic).toLowerCase();
      final summary = article.getSummary(isArabic).toLowerCase();
      final category = article.getCategoryTag(isArabic);
      final query = _searchQuery.trim().toLowerCase();

      final matchesQuery = query.isEmpty ||
          title.contains(query) ||
          summary.contains(query) ||
          article
              .getBulletPoints(isArabic)
              .any((bp) => bp.toLowerCase().contains(query));

      final matchesCategory =
          _selectedCategory == null || category == _selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();

    // Unique category list for filter chips
    final allCategories = mockAwarenessArticles
        .map((a) => a.getCategoryTag(isArabic))
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppTranslations.tr('awarenessScreenTitle', isArabic),
          style: GoogleFonts.elMessiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        actions: const [
          AppBarLanguageSwitch(),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Header Banner & Educational Medical Disclaimer
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildScreenHeader(isArabic),
                    const SizedBox(height: 12),
                    _buildDisclaimerNotice(isArabic),
                    const SizedBox(height: 16),
                    _buildSearchBar(isArabic),
                    const SizedBox(height: 12),
                    _buildCategoryChips(allCategories, isArabic),
                    const SizedBox(height: 12),
                    // Results count label
                    Text(
                      '${filteredArticles.length} ${AppTranslations.tr('articlesCount', isArabic)}',
                      style: GoogleFonts.elMessiri(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Expandable Articles List
            if (filteredArticles.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyState(isArabic),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final article = filteredArticles[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildArticleExpandableCard(
                            context, article, isArabic),
                      );
                    },
                    childCount: filteredArticles.length,
                  ),
                ),
              ),

            // Bottom padding for scroll comfort
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  /// Screen Intro Header
  Widget _buildScreenHeader(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.tr('awarenessScreenTitle', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppTranslations.tr('awarenessScreenSubtitle', isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Educational Disclaimer Card
  Widget _buildDisclaimerNotice(bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.softPink.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.pinkAccent.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppTranslations.tr('awarenessDisclaimer', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Search Bar with clear action
  Widget _buildSearchBar(bool isArabic) {
    return TextField(
      controller: _searchController,
      onChanged: (val) {
        setState(() {
          _searchQuery = val;
        });
      },
      style: GoogleFonts.elMessiri(
        fontSize: 14,
        color: AppColors.darkText,
      ),
      decoration: InputDecoration(
        hintText: AppTranslations.tr('searchArticlesHint', isArabic),
        hintStyle: GoogleFonts.elMessiri(
          fontSize: 13,
          color: Colors.grey.shade500,
        ),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
      ),
    );
  }

  /// Horizontal scrollable category filter chips
  Widget _buildCategoryChips(List<String> categories, bool isArabic) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: 6, left: 6),
            child: ChoiceChip(
              label: Text(
                AppTranslations.tr('allArticlesFilter', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _selectedCategory == null
                      ? Colors.white
                      : AppColors.primary,
                ),
              ),
              selected: _selectedCategory == null,
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: _selectedCategory == null
                      ? AppColors.primary
                      : Colors.grey.shade300,
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = null;
                  });
                }
              },
            ),
          ),
          ...categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 6, left: 6),
              child: ChoiceChip(
                label: Text(
                  cat,
                  style: GoogleFonts.elMessiri(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.darkText,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? cat : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Accessible Expandable Card displaying the complete verified article
  Widget _buildArticleExpandableCard(
    BuildContext context,
    AwarenessArticle article,
    bool isArabic,
  ) {
    final bullets = article.getBulletPoints(isArabic);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Theme(
          // Remove expansion tile default dividing borders
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.softPink.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              article.icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category tag pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.pinkAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  article.getCategoryTag(isArabic),
                  style: GoogleFonts.elMessiri(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                article.getTitle(isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                  height: 1.3,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              article.getSummary(isArabic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.elMessiri(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.35,
              ),
            ),
          ),
          children: [
            const Divider(height: 16, color: Color(0xFFEEEEEE)),

            // Full Summary paragraph
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFD),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                article.getSummary(isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 13,
                  color: AppColors.darkText,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Key Points Header
            Align(
              alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                AppTranslations.tr('keyPointsTitle', isArabic),
                style: GoogleFonts.elMessiri(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Bullet points
            ...bullets.map(
              (bp) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        bp,
                        style: GoogleFonts.elMessiri(
                          fontSize: 13,
                          color: AppColors.darkText,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Reassurance Advice Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.pinkAccent.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.tr('keyTakeawayTitle', isArabic),
                          style: GoogleFonts.elMessiri(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.getAdvice(isArabic),
                          style: GoogleFonts.elMessiri(
                            fontSize: 12,
                            color: AppColors.darkText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Source verification metadata & direct reference link
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppTranslations.tr('sourceVerifiedLabel', isArabic),
                        style: GoogleFonts.elMessiri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          article.sourceName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.elMessiri(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${AppTranslations.tr('dateCheckedLabel', isArabic)} ${article.getDateChecked(isArabic)}',
                        style: GoogleFonts.elMessiri(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Link Button
                  OutlinedButton.icon(
                    onPressed: () =>
                        _openSourceUrl(context, article.sourceUrl, isArabic),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: Text(
                      AppTranslations.tr('visitSourceLink', isArabic),
                      style: GoogleFonts.elMessiri(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

  /// Empty state when search or filter returns no results
  Widget _buildEmptyState(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 54,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              AppTranslations.tr('noArticlesFound', isArabic),
              style: GoogleFonts.elMessiri(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppTranslations.tr('noArticlesFoundDesc', isArabic),
              textAlign: TextAlign.center,
              style: GoogleFonts.elMessiri(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = null;
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                AppTranslations.tr('allArticlesFilter', isArabic),
                style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
