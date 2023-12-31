import 'package:flutter/material.dart';
import 'package:nearby_cross_example/widgets/nc_appBar.dart';

class AdvertiserList extends StatelessWidget {
  const AdvertiserList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: const NCAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 20),
                child: Text(
                  "Connect to a Advertiser",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 24,
                    color: Color(0xff272727),
                  ),
                ),
              ),
              ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_box_outlined,
                              color: Color(0xff212435),
                              size: 24,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "DISCOVERER #1",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Full Stack developer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.login,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn3.iconfinder.com/data/icons/logos-brands-3/24/logo_brand_brands_logos_google-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "JP",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Senior UI/UX Designer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn3.iconfinder.com/data/icons/social-media-2169/24/social_media_social_media_logo_dribbble-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Dribbble",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Interaction Designer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn3.iconfinder.com/data/icons/logos-brands-3/24/logo_brand_brands_logos_dropbox-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Dropbox Inc.",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Mobile App developer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn2.iconfinder.com/data/icons/social-var-1/614/4_-_Behance-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Behance",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Illustration Artist",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn4.iconfinder.com/data/icons/social-media-logos-6/512/78-microsoft-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Microdoft",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Full Stack developer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn3.iconfinder.com/data/icons/logos-brands-3/24/logo_brand_brands_logos_google-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Google LLC",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Senior UI/UX Designer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn3.iconfinder.com/data/icons/social-media-2169/24/social_media_social_media_logo_dribbble-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Dribbble",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Interaction Designer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn3.iconfinder.com/data/icons/logos-brands-3/24/logo_brand_brands_logos_dropbox-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Dropbox Inc.",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Mobile App developer",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child:

                                ///***If you have exported images you must have to copy those images in assets/images directory.
                                const Image(
                              image: NetworkImage(
                                  "https://cdn2.iconfinder.com/data/icons/social-var-1/614/4_-_Behance-128.png"),
                              height: 20,
                              width: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Behance",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      "Illustration Artist",
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff6c6c6c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff3a57e8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.work_outlined,
                              color: Color(0xffffffff),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
