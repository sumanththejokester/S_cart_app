import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class FullScreenImageScreen extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenImageScreen({Key? key, required this.imagesList})
      : super(key: key);

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Text(
              // ignore: prefer_adjacent_string_concatenation
              ('${index + 1}' + ' / ' + widget.imagesList.length.toString()),
              style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 18,
                  letterSpacing: 1.5),
            )),
            // ignore: sized_box_for_whitespace
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              //decoration: BoxDecoration(border: Border.all()),
              child: PageView(
                onPageChanged: ((value) {
                  setState(() {
                    index = value;
                  });
                }),
                controller: _controller,
                children: images(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: imageView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _controller.jumpToPage(index);
            },
            child: Container(
                margin: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imagesList[index],
                    fit: BoxFit.cover,
                  ),
                )),
          );
        });
  }

  List<Widget> images() {
    return List.generate(widget.imagesList.length, (index) {
      return InteractiveViewer(
          transformationController: TransformationController(),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.imagesList[index].toString(),
                //fit: BoxFit.cover,
              )));
    });
  }
}
