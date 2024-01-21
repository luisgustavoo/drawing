import 'package:bloc/bloc.dart';
import 'package:drawing_test/cubit/home_page_state.dart';
import 'package:drawing_test/models/draw_lines.dart';
import 'package:flutter/material.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageState.initial());

  void createLine({
    required DrawLine line,
  }) {
    emit(state.copyWith(lines: [line]));
  }

  void updateLines({
    required Offset point,
  }) {
    state.lines.last.path.add(point);
    final newLine = [...state.lines];
    emit(state.copyWith(lines: newLine));
  }

  void updateStrokeLine() {}
}
