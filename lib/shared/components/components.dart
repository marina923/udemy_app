import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUppercase = true,
  double radius = 0.0,
  @required String text,
  @required Function function,
}) =>
    Container(
      height: 40.0,
      width: width,
      child: MaterialButton(
        child: Text(isUppercase ? text.toUpperCase() : text),
        textColor: Colors.white,
        onPressed: function,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
Widget defaultTextFormField({
  @required TextEditingController controller,
  @required String label,
  @required IconData prefix,
  Function onSubmit,
  Function onChange,
  @required TextInputType type,
  bool isPassword = false,
  @required Function validate,
  IconData sufix,
  Function suffixPressed,
  Function tap,
  bool isClickable,
}) =>
    TextFormField(
      enabled: isClickable,
      onTap: tap,
      onChanged: onChange,
      controller: controller,
      onFieldSubmitted: onSubmit,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: sufix != null
            ? IconButton(
                icon: Icon(sufix),
                onPressed: suffixPressed,
              )
            : null,
        border: OutlineInputBorder(),
      ),
      validator: validate,
    );
Widget buildTaskItem(Map model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text('${model['time']}'),
          ),
          SizedBox(
            width: 20.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
