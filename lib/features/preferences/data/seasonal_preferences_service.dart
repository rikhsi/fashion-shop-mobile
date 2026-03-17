import 'package:flutter/foundation.dart';

/// Full preferences for one season (styles, colors, fabrics, etc.)
class SeasonalPrefs {
  final Set<String> styles;
  final Set<String> colors;
  final Set<String> fabrics;
  final Set<String> categories;
  final Set<String> occasions;
  final Set<String> fits;

  const SeasonalPrefs({
    this.styles = const {},
    this.colors = const {},
    this.fabrics = const {},
    this.categories = const {},
    this.occasions = const {},
    this.fits = const {},
  });

  SeasonalPrefs copyWith({
    Set<String>? styles,
    Set<String>? colors,
    Set<String>? fabrics,
    Set<String>? categories,
    Set<String>? occasions,
    Set<String>? fits,
  }) {
    return SeasonalPrefs(
      styles: styles ?? this.styles,
      colors: colors ?? this.colors,
      fabrics: fabrics ?? this.fabrics,
      categories: categories ?? this.categories,
      occasions: occasions ?? this.occasions,
      fits: fits ?? this.fits,
    );
  }

  int get totalSelected =>
      styles.length +
      colors.length +
      fabrics.length +
      categories.length +
      occasions.length +
      fits.length;

  Set<String> getByKey(String key) {
    switch (key) {
      case 'styles':
        return Set.from(styles);
      case 'colors':
        return Set.from(colors);
      case 'fabrics':
        return Set.from(fabrics);
      case 'categories':
        return Set.from(categories);
      case 'occasions':
        return Set.from(occasions);
      case 'fits':
        return Set.from(fits);
      default:
        return {};
    }
  }
}

/// Stores full preferences per season for feed personalization.
class SeasonalPreferencesService extends ChangeNotifier {
  final Map<String, SeasonalPrefs> _bySeason = {
    'Spring': const SeasonalPrefs(),
    'Summer': const SeasonalPrefs(),
    'Autumn': const SeasonalPrefs(),
    'Winter': const SeasonalPrefs(),
  };

  SeasonalPrefs getSeason(String season) =>
      _bySeason[season] ?? const SeasonalPrefs();

  void toggle(String season, String category, String value) {
    final prev = _bySeason[season] ?? const SeasonalPrefs();
    Set<String> set;
    switch (category) {
      case 'styles':
        set = Set.from(prev.styles);
        break;
      case 'colors':
        set = Set.from(prev.colors);
        break;
      case 'fabrics':
        set = Set.from(prev.fabrics);
        break;
      case 'categories':
        set = Set.from(prev.categories);
        break;
      case 'occasions':
        set = Set.from(prev.occasions);
        break;
      case 'fits':
        set = Set.from(prev.fits);
        break;
      default:
        return;
    }
    if (set.contains(value)) {
      set.remove(value);
    } else {
      set.add(value);
    }
    switch (category) {
      case 'styles':
        _bySeason[season] = prev.copyWith(styles: set);
        break;
      case 'colors':
        _bySeason[season] = prev.copyWith(colors: set);
        break;
      case 'fabrics':
        _bySeason[season] = prev.copyWith(fabrics: set);
        break;
      case 'categories':
        _bySeason[season] = prev.copyWith(categories: set);
        break;
      case 'occasions':
        _bySeason[season] = prev.copyWith(occasions: set);
        break;
      case 'fits':
        _bySeason[season] = prev.copyWith(fits: set);
        break;
    }
    notifyListeners();
  }

  void setSeason(String season, SeasonalPrefs prefs) {
    _bySeason[season] = prefs;
    notifyListeners();
  }

  /// Returns full map of season -> prefs (for loading)
  Map<String, SeasonalPrefs> getAll() {
    return Map.from(_bySeason);
  }

  /// Sets all seasonal preferences at once
  void setAll(Map<String, SeasonalPrefs> data) {
    for (final e in data.entries) {
      if (_bySeason.containsKey(e.key)) {
        _bySeason[e.key] = e.value;
      }
    }
    notifyListeners();
  }
}
