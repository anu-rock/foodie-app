/// Represents an item of type T that may be marked as selected via its
/// `isSelected` field.
///
/// When its value is compared with another [SelectableItem],
/// for example while sorting in a list, it will come before
/// the other item if it is selected.
class SelectableItem<T> implements Comparable<SelectableItem<T>> {
  /// The item that we care about.
  Comparable<T> item;

  /// Whether the item is selected.
  bool isSelected;

  SelectableItem({
    this.item,
    this.isSelected,
  });

  @override
  int compareTo(SelectableItem<T> other) {
    if (this.isSelected && !other.isSelected) {
      return -1;
    } else if (!this.isSelected && other.isSelected) {
      return 1;
    }
    return this.item.compareTo(other.item as T);
  }
}
