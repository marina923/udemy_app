import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:udemy_app/shared/cubit/cubit.dart';

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

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        appCubit.get(context).deleteDatabase(id: model['id']);
      },
      child: Padding(
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
            Expanded(
              child: Column(
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
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                appCubit.get(context).updateDatabase(
                      status: 'done',
                      id: model['id'],
                    );
              },
              icon: Icon(
                Icons.check_box_sharp,
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: 1.0,
            ),
            IconButton(
              onPressed: () {
                appCubit.get(context).updateDatabase(
                      status: 'archive',
                      id: model['id'],
                    );
              },
              icon: Icon(
                Icons.archive_outlined,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
Widget buildCondition({@required List<Map> tasks}) => ConditionalBuilder(
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.black45,
              size: 100.0,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20.0,
          ),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
        itemCount: tasks.length,
      ),
    );
