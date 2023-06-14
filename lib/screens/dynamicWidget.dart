import 'package:flutter/material.dart';

class StreamBuilderIssue extends StatefulWidget {

  @override
  _StreamBuilderIssueState createState() => _StreamBuilderIssueState();

}

class _StreamBuilderIssueState extends State<StreamBuilderIssue> {

  List<ServiceCard> serviceCardList;
  int numElements = 1; //dynamic number of elements

  void removeServiceCard(index) {
    setState(() {
      serviceCardList.remove(index);
      numElements--;
    });
  }

  @override
  Widget build(BuildContext context) {
    serviceCardList = List.generate(numElements, (index) => ServiceCard(removeServiceCard, index: index, key: null,));
    return Scaffold(
      body: ListView(

        children: <Widget>[
          ...serviceCardList,
          new FlatButton(
            onPressed: (){
              setState(() {
                numElements++;
              });
            },
            child: new Icon(Icons.add),
          ),
        ],

      ),
    );
  }

}

class ServiceCard extends StatelessWidget {

  final int index;
  final Function(ServiceCard) removeServiceCard;

  const ServiceCard(this.removeServiceCard, {required Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Text('Index: ${index.toString()} Hashcode: ${this.hashCode.toString()}'),
        RaisedButton(
          color: Colors.accents.elementAt(3 * index),
          onPressed: () {
            removeServiceCard(this);
          },
          child: Text('Delete me'),
        ),

      ],
    );
  }

}