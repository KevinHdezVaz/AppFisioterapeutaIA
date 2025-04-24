import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:quicklai/model/image_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:share_plus/share_plus.dart';

import '../../constant/show_toast_dialog.dart';

class ImageView extends StatefulWidget {
  final int index;
  final List<ImageData> imageList;

  const ImageView({super.key, required this.index, required this.imageList});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final CarouselSliderController _controller = CarouselSliderController();

  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.background,
      appBar: AppBar(
        title: Text('Image'.tr),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    // Lógica de descarga
                  },
                  child: const Icon(Icons.download, color: Colors.white),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    ShowToastDialog.showLoader('Please wait ....'.tr);
                    http.Response response = await http.get(Uri.parse(
                        widget.imageList[_currentIndex].url.toString()));

                    final directory = await getTemporaryDirectory();
                    final path = directory.path;
                    final file = File('$path/image.png');
                    file.writeAsBytes(response.bodyBytes);
                    ShowToastDialog.closeLoader();
                    //    Share.shareFiles(['$path/image.png']);
                  },
                  child: const Icon(Icons.share),
                ),
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Builder(
            builder: (context) {
              final double height = MediaQuery.of(context).size.height;
              return CarouselSlider(
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: _currentIndex,
                  onPageChanged: (index, reason) {
                    _currentIndex = index;
                    setState(() {});
                  },
                ),
                carouselController: _controller,
                items: widget.imageList
                    .map((item) => Center(
                          child: CachedNetworkImage(
                            imageUrl: item.url.toString(),
                            fit: BoxFit.none,
                            height: height,
                            placeholder: (context, url) => Container(
                              color: const Color(0xfff5f8fd),
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    // Lógica de descarga
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ConstantColors.cardViewColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.download, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Download'.tr,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
