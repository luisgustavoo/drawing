import 'package:drawing_test/models/draw_lines.dart';
import 'package:equatable/equatable.dart';

class HomePageState extends Equatable {
  const HomePageState._({
    required this.lines,
  });

  HomePageState.initial() : this._(lines: []);

  final List<DrawLine> lines;

  @override
  List<Object?> get props => [lines];

  HomePageState copyWith({
    List<DrawLine>? lines,
  }) {
    return HomePageState._(
      lines: lines ?? this.lines,
    );
  }
}
