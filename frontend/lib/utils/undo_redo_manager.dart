class UndoRedoManager<T> {
  final List<T> _undoStack = [];
  final List<T> _redoStack = [];
  final int maxStackSize;

  UndoRedoManager({this.maxStackSize = 50});

  void saveState(T state) {
    _undoStack.add(state);
    _redoStack.clear(); // Clear redo stack when new action is performed
    
    // Limit stack size
    if (_undoStack.length > maxStackSize) {
      _undoStack.removeAt(0);
    }
  }

  T? undo() {
    if (!canUndo) return null;
    
    final currentState = _undoStack.removeLast();
    _redoStack.add(currentState);
    
    return _undoStack.isNotEmpty ? _undoStack.last : null;
  }

  T? redo() {
    if (!canRedo) return null;
    
    final state = _redoStack.removeLast();
    _undoStack.add(state);
    
    return state;
  }

  bool get canUndo => _undoStack.length > 1;
  bool get canRedo => _redoStack.isNotEmpty;

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }

  int get undoCount => _undoStack.length;
  int get redoCount => _redoStack.length;
}

// Task action for undo/redo
class TaskAction {
  final String type; // 'create', 'update', 'delete'
  final Map<String, dynamic> data;
  final DateTime timestamp;

  TaskAction({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  TaskAction copyWith({
    String? type,
    Map<String, dynamic>? data,
    DateTime? timestamp,
  }) {
    return TaskAction(
      type: type ?? this.type,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
