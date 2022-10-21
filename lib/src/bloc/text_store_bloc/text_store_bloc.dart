import 'package:flutter_bloc/flutter_bloc.dart';

class TextStoreBloc extends Bloc<TextStoreEvent, TextStoreState> {
  TextStoreBloc(super.initialState) {
    on<TextStoreFormAdded>((event, Emitter<TextStoreState> emit) {
      _addForm(form:event.form, emit:emit);
    });

    on<TextStoreFormRemoved>((event, Emitter<TextStoreState> emit) {
      _removeForm(formName: event.formName, emit: emit);
    });

    on<TextStoreFieldAdded>((event, Emitter<TextStoreState> emit) {
      emit(TextStoreState(textForms: state.textForms));
    });
  }

  void _addForm({required TextStoreForm form, required Emitter<TextStoreState> emit}) {
    TextStoreForm? existForm = _fetchForm(form.name);
    if(existForm==null) {
      emit(TextStoreState(textForms:state.textForms..add(form)));
    }
    throw Exception('Form already exists');
  }

  void _removeForm({required String formName, required Emitter<TextStoreState> emit}) {
    TextStoreForm? existForm = _fetchForm(formName);
    if(existForm==null) {
      throw Exception('Form not founded');
    }
    List<TextStoreForm> currentForms = List.of(state.textForms);
    currentForms.remove(existForm);
    emit(TextStoreState(textForms:currentForms));
  }

  TextStoreForm? _fetchForm(String formName) {
    List<TextStoreForm> formsList = state.textForms.where((form)=>form.name==formName).toList();
    TextStoreForm form;
    if(formsList.length==1) {
      form = formsList.single;
      return form;
    }
    return null;
  }
}

class TextStoreState {
  final List<TextStoreForm> textForms;
  TextStoreState({required this.textForms});
}
class TextStoreEvent {}

class TextStoreFieldAdded extends TextStoreEvent {
  String formName;
  TextStoreField field;
  TextStoreFieldAdded({required this.formName, required this.field});
}

class TextStoreFieldChanged extends TextStoreEvent {
  String formName;
  String fieldName;
  String text;
  TextStoreFieldChanged({required this.formName, required this.fieldName, required this.text});
}
class TextStoreFieldCleared extends TextStoreEvent {
  String formName;
  String fieldName;
  TextStoreFieldCleared({required this.formName, required this.fieldName});
}
class TextStoreFieldRemoved extends TextStoreEvent {
  String formName;
  String fieldName;
  TextStoreFieldRemoved({required this.formName, required this.fieldName});
}
class TextStoreFormAdded extends TextStoreEvent {
  TextStoreForm form;
  TextStoreFormAdded({required this.form});
}
class TextStoreFormRemoved extends TextStoreEvent {
  String formName;
  TextStoreFormRemoved({required this.formName});
}

class TextStoreForm {
  final List<TextStoreField> _fields = [];
  final String name;
  TextStoreForm({required this.name});

  bool fieldIsValid(String fieldName) {
    TextStoreField? existField = _fetchField(fieldName);
    if(existField==null) {
      throw Exception('Field not found');
    }
    return existField.isValid;
  }

  void addField(TextStoreField field) {
    TextStoreField? existField = _fetchField(field.name);
    if(existField==null) {
      _fields.add(field);
    }
    throw Exception('Field already exists');
  }

  void clearFieldText(String fieldName) {
    TextStoreField? existField = _fetchField(fieldName);
    if(existField==null) {
      throw Exception('Field not found');
    }
    int fieldIndex = _fields.indexOf(existField);
    TextStoreField clearedField = existField..currentText = '';
    _fields[fieldIndex]=clearedField;
  }

  void changeFieldText(String fieldName, String text) {
    TextStoreField? existField = _fetchField(fieldName);
    if(existField==null) {
      throw Exception('Field not found');
    }
    int fieldIndex = _fields.indexOf(existField);
    TextStoreField fieldWithNewText = existField..currentText = text;
    _fields[fieldIndex]=fieldWithNewText;
  }

  void deleteField(String fieldName) {
    TextStoreField? existField = _fetchField(fieldName);
    if(existField==null) {
      throw Exception('Field not found');
    }
    _fields.remove(existField);
  }

  void clearForm() {
    _fields.clear();
  }

  TextStoreField? _fetchField(String fieldName) {
    List<TextStoreField> fieldsList = _fields.where((field)=>field.name==fieldName).toList();
    TextStoreField field;
    if(fieldsList.length==1) {
      field = fieldsList.single;
      return field;
    }
    return null;
  }
}

class TextStoreField {
  final String name;
  String currentText;
  final TextStoreValidation? validation;

  TextStoreField({required this.name, this.currentText='', this.validation});
  bool get isValid {
      if(currentText.length == (validation?.textLength ?? currentText.length)) {
        if((validation?.pattern?.hasMatch(currentText) ?? true)) {
          return true;
        }
      }
      return false;
  }
}

class TextStoreValidation {
  final RegExp? pattern;
  final int? textLength;

  TextStoreValidation({this.pattern, this.textLength});
}

