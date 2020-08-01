import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';
import 'package:rndroma/database/app_database.dart';

import 'cluster_maps/pages/cluster_maps_page.dart';

void main() {
//  Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase = AppDatabase();

  List iniList = ['satu', 'dua', 'tiga'];

  Map<String, dynamic> iniMap = {
    "satu": "iniSatu",
  };

  bool checkValue() {
    iniList.contains('satu');
    iniMap.containsKey('hallloo');
    iniMap.containsValue("haloo");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => appDatabase.taskDao),
        Provider(create: (_) => appDatabase.tagDao),
      ],
      child: MaterialApp(
        title: 'Material App',
        home: ClusterMapsPage(),
//        home: HomePage(),
//        home: BlocCubitPage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

class _HomePageState extends State<HomePage> {
  bool showCompleted = false;
  String value;
  Color color;

  @override
  void initState() {
    super.initState();
    value = '';
    color = Colors.black87;
    locationaaa();
  }

  void locationaaa() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(-7.9797, 112.6304);
    print(placemark[0].country);
    print(placemark[0].position);
    print(placemark[0].locality);
    print(placemark[0].administrativeArea);
    print(placemark[0].postalCode);
    print(placemark[0].name);
    print(placemark[0].subAdministrativeArea);
    print(placemark[0].isoCountryCode);
    print(placemark[0].subLocality);
    print(placemark[0].subThoroughfare);
    print(placemark[0].thoroughfare);

    setState(() {
      String address = placemark[0].thoroughfare +
          " " +
          placemark[0].subThoroughfare +
          ", " +
          placemark[0].subLocality +
          ", " +
          placemark[0].locality;

      String city = placemark[0].subAdministrativeArea;

      String province = placemark[0].administrativeArea;

      String country = placemark[0].country;
      value = 'Lat: -7.9797, Lng: 112.6304 berada di\n$address, $city, $province, $country';
      color = Colors.black87;
    });

    var currentLocation =
        await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    double distanceInMeters = await Geolocator().distanceBetween(
        currentLocation.latitude, currentLocation.longitude, -7.9536326, 112.6442925);

//    Geolocator()
//        .getPositionStream(LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 1000))
//        .listen((position) {
//      // Do something here
//      setState(() {
//        value = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
//        color = randomColor();
//      });
//    });
//    setState(() {
//      value = distanceInMeters.toString();
//      color = Colors.black87;
//    });
    print('DISTANCE : $distanceInMeters');
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.9797, 112.6304),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: <Widget>[_buildCompletedOnlySwitch()],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$value',
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
//      body: Column(
//        children: <Widget>[
//          Expanded(
//            child: _buildTaskList(context),
//          ),
//          NewTaskInput(),
//          NewTagInput(),
//        ],
//      ),
    );
  }

  Row _buildCompletedOnlySwitch() {
    return Row(
      children: <Widget>[
        Text('Completed only'),
        Switch(
          value: showCompleted,
          activeColor: Colors.white,
          onChanged: (val) {
            setState(() {
              showCompleted = val;
            });
          },
        )
      ],
    );
  }

  StreamBuilder<List<TaskWithTag>> _buildTaskList(BuildContext context) {
    final dao = Provider.of<TaskDao>(context);
    return StreamBuilder(
      stream: showCompleted ? dao.watchCompletedTaskWithTag() : dao.watchAllTaskWithTag(),
      builder: (context, AsyncSnapshot<List<TaskWithTag>> snapshot) {
        final tasks = snapshot.data ?? List();

        IdHelper.id = tasks.length + 1;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final item = tasks[index];
            return _buildListItem(item, dao);
          },
        );
      },
    );
  }

  Widget _buildListItem(TaskWithTag item, TaskDao dao) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => dao.deleteTask(item.task),
        )
      ],
      child: CheckboxListTile(
        title: Text(item.task.name),
        subtitle: Text(item.task.dueDate?.toString() ?? 'No date'),
        secondary: _buildTag(item.tag),
        value: item.task.completed,
        onChanged: (newValue) {
          dao.updateTask(item.task.copyWith(completed: newValue));
        },
      ),
    );
  }

  Column _buildTag(Tag tag) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tag != null) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(tag.color),
            ),
          ),
          Text(tag.name),
        ],
      ],
    );
  }
}

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({
    Key key,
  }) : super(key: key);

  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  DateTime newTaskDate;
  TextEditingController controller;
  Tag selectedTag;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context),
          // for tag
          _buildTagSelector(context),
          IconButton(
            onPressed: () {
              final dao = Provider.of<TaskDao>(context, listen: false);
              final task = TasksCompanion(
                id: moor.Value(IdHelper.id),
                name: moor.Value(controller.text),
                dueDate: moor.Value(newTaskDate),
                tagName: moor.Value(selectedTag?.name),
              );
              dao.insertTask(task);
              resetValuesAfterSubmit();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Task Name'),
      ),
    );
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        );
      },
    );
  }

  StreamBuilder<List<Tag>> _buildTagSelector(BuildContext context) {
    return StreamBuilder<List<Tag>>(
      stream: Provider.of<TagDao>(context).watchTags(),
      builder: (context, snapshot) {
        final tags = snapshot.data ?? List();

        DropdownMenuItem<Tag> dropdownFromTag(Tag tag) {
          return DropdownMenuItem(
            value: tag,
            child: Row(
              children: <Widget>[
                Text(tag.name),
                SizedBox(width: 5),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(tag.color),
                  ),
                ),
              ],
            ),
          );
        }

        final dropdownMenuItems = tags.map((tag) => dropdownFromTag(tag)).toList()
          // Add a "no tag" item as the first element of the list
          ..insert(
            0,
            DropdownMenuItem(
              value: null,
              child: Text('No Tag'),
            ),
          );

        return Expanded(
          child: DropdownButton(
            onChanged: (Tag tag) {
              setState(() {
                selectedTag = tag;
              });
            },
            isExpanded: true,
            value: selectedTag,
            items: dropdownMenuItems,
          ),
        );
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null;
      controller.clear();
    });
  }
}

class NewTagInput extends StatefulWidget {
  const NewTagInput({
    Key key,
  }) : super(key: key);

  @override
  _NewTagInputState createState() => _NewTagInputState();
}

class _NewTagInputState extends State<NewTagInput> {
  static const Color DEFAULT_COLOR = Colors.red;

  Color pickedTagColor = DEFAULT_COLOR;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          _buildTextField(context),
          _buildColorPickerButton(context),
          IconButton(
            onPressed: () {
              final dao = Provider.of<TagDao>(context, listen: false);
              final task = TagsCompanion(
                name: moor.Value(controller.text),
                color: moor.Value(pickedTagColor.value),
              );
              dao.insertTag(task);
              resetValuesAfterSubmit();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Flexible _buildTextField(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Tag Name'),
      ),
    );
  }

  Widget _buildColorPickerButton(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pickedTagColor,
          ),
        ),
        onTap: () {
          _showColorPickerDialog(context);
        },
      ),
    );
  }

  Future _showColorPickerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: MaterialColorPicker(
            allowShades: false,
            selectedColor: DEFAULT_COLOR,
            onMainColorChange: (colorSwatch) {
              setState(() {
                pickedTagColor = colorSwatch;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      pickedTagColor = DEFAULT_COLOR;
      controller.clear();
    });
  }
}

class IdHelper {
  static int id;
}
