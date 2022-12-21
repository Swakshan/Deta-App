import 'package:deta/assets/Constants.dart';
import 'package:deta/models/ProgramModel.dart';
import 'package:deta/models/ProjectModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/widgets/AlertDialog.dart';
import 'package:deta/widgets/AppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';

class AllBases extends StatefulWidget {
  final DetaAPI detaAPI;
  final ProjectModel projectModel;
  const AllBases({Key? key,required this.detaAPI,required this.projectModel}) : super(key: key);


  @override
  State<AllBases> createState() => _AllBasesState();
}

class _AllBasesState extends State<AllBases> {
  late Future<List?> allList;

  Future<List?> getBasesList(bool refresh) async {
    var data;
    String project_id = widget.projectModel.id;
    data = await widget.detaAPI.getBases(project_id,refresh);

    // if(data==null){
    //   toaster(context, ERROR, ERROR, ContentType.failure);
    //
    // }
    // print(data.runtimeType);
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildAppBar(context,BASE_TITLE),
      body: RefreshIndicator(
        onRefresh: ()async{
          // allProjects = getProjectList(true);
          allList = getBasesList(true);
          setState(() {
          });
        },
        child: FutureBuilder(
          future: allList,
          builder: (context, AsyncSnapshot<List?> snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {

              if (snapshot.data != null) {
                return buildContent(snapshot.data!);
              }
              return Center(
                child: Text(
                  EMPTY_LIST.format("bases"),
                  style: TextStyle(fontSize: 24),
                ),
              );
            }
            return const SizedBox.shrink();
          },),

      ),

    );
  }

  Widget buildContent(List items) {

    if (items.isEmpty) {
      return Center(
        child: Text(
          EMPTY_LIST.format("bases"),
          style: TextStyle(fontSize: 24),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        String baseName = items[index];
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: ()async{
              // await Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => TabProjectPage(detaAPI: detaAPI)));
              return;
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
              elevation: 10,
              shadowColor: Theme.of(context).primaryColor,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(baseName[0],
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                title: Text(
                  baseName,
                  style: TextStyle(fontSize: 30),
                ),
                // subtitle: Container(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           projectModel.id.toString(),
                //           style: TextStyle(fontSize: 25),
                //         )
                //       ],
                //     )),
                trailing: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () async {

                      // ShowInfoSheet(projectModel);
                      return;
                    }),
              ),
            ),
          ),
        );
      },
    );


  }

  @override
  void initState() {
    allList = getBasesList(false);
    super.initState();
  }
}
