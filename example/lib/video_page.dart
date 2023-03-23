import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fplayer/fplayer.dart';

import 'app_bar.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  const VideoScreen({super.key, required this.url});

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  final FPlayer player = FPlayer();

  // 视频列表
  List<VideoItem> videoList = [
    VideoItem(
      title: '第一集',
      subTitle: '视频1副标题',
      url: 'http://player.alicdn.com/video/aliyunmedia.mp4',
    ),
    VideoItem(
      title: '第二集',
      subTitle: '视频2副标题',
      url: 'https://www.runoob.com/try/demo_source/mov_bbb.mp4',
    ),
    VideoItem(
      title: '第三集',
      subTitle: '视频3副标题',
      url: 'http://player.alicdn.com/video/aliyunmedia.mp4',
    ),
    VideoItem(
      title: '第四集',
      subTitle: '视频4副标题',
      url: 'https://www.runoob.com/try/demo_source/mov_bbb.mp4',
    ),
    VideoItem(
      title: '第五集',
      subTitle: '视频5副标题',
      url: 'http://player.alicdn.com/video/aliyunmedia.mp4',
    ),
    VideoItem(
      title: '第六集',
      subTitle: '视频6副标题',
      url: 'https://www.runoob.com/try/demo_source/mov_bbb.mp4',
    ),
    VideoItem(
      title: '第七集',
      subTitle: '视频7副标题',
      url: 'http://player.alicdn.com/video/aliyunmedia.mp4',
    )
  ];

  Map<String, double> speedList = {
    "2.0": 2.0,
    "1.5": 1.5,
    "1.0": 1.0,
    "0.5": 0.5,
  };

  Map<String, ResolutionItem> resolutionList = {
    "480P": ResolutionItem(
      value: 480,
      url: 'https://www.runoob.com/try/demo_source/mov_bbb.mp4',
    ),
    "270P": ResolutionItem(
      value: 270,
      url: 'http://player.alicdn.com/video/aliyunmedia.mp4',
    ),
  };

  int videoIndex = 0;

  VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setOption(FOption.hostCategory, "enable-snapshot", 1);
    player.setOption(FOption.playerCategory, "mediacodec-all-videos", 1);
    startPlay();
  }

  void startPlay() async {
    await player.setOption(FOption.hostCategory, "enable-snapshot", 1);
    await player.setOption(FOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FOption.hostCategory, "request-audio-focus", 1);
    await player.setOption(FOption.playerCategory, "reconnect", 20);
    await player.setOption(FOption.playerCategory, "framedrop", 20);
    await player.setOption(FOption.playerCategory, "enable-accurate-seek", 1);
    await player.setOption(FOption.playerCategory, "mediacodec", 1);
    await player.setOption(FOption.playerCategory, "packet-buffering", 0);
    await player.setOption(FOption.playerCategory, "soundtouch", 1);
    await player.setDataSource(widget.url, autoPlay: true).catchError((e) {
      if (kDebugMode) {
        print("setDataSource error: $e");
      }
    });
  }

  Future<void> setVideoUrl(String url) async {
    try {
      await player.setDataSource(url, autoPlay: true, showCover: true);
    } catch (error) {
      print("播放-异常: $error");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double videoHeight = size.width * 9 / 16;
    return Scaffold(
      appBar: const FAppBar.defaultSetting(title: "Video"),
      body: Column(
        children: [
          FView(
            player: player,
            width: double.infinity,
            height: videoHeight,
            color: Colors.black,
            fsFit: FFit.contain, // 全屏模式下的填充
            fit: FFit.fill, // 正常模式下的填充
            panelBuilder: fPanel2Builder(
              // 单视频配置
              title: '视频标题',
              subTitle: '视频副标题',
              // 右下方截屏按钮
              snapShot: true,
              // 右上方按钮组开关
              rightButton: true,
              // 右上方按钮组
              rightButtonList: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(5),
                      ),
                    ),
                    child: Icon(
                      Icons.thumb_up,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
              // 字幕功能：待内核提供api
              // caption: true,
              // 视频列表开关
              videos: true,
              // 视频列表列表
              videoMap: videoList,
              // 当前视频索引
              videoIndex: videoIndex,
              // 播放下一集视频回调
              playNextVideoFun: () {
                setState(() {
                  videoIndex += 1;
                });
              },
              settingFun: () {
                print('设置按钮点击事件');
              },
              // 自定义倍速列表
              speedList: speedList,
              // 清晰度开关
              resolution: true,
              // 自定义清晰度列表
              resolutionList: resolutionList,
            ),
          ),
          // 自定义小屏列表
          Container(
            width: double.infinity,
            height: 30,
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                bool isCurrent = videoIndex == index;
                Color textColor = Theme.of(context).primaryColor;
                Color bgColor = Theme.of(context).primaryColorDark;
                Color borderColor = Theme.of(context).primaryColor;
                if (isCurrent) {
                  textColor = Theme.of(context).primaryColorDark;
                  bgColor = Theme.of(context).primaryColor;
                  borderColor = Theme.of(context).primaryColor;
                }
                return GestureDetector(
                  onTap: () async {
                    await player.reset();
                    setState(() {
                      videoIndex = index;
                    });
                    setVideoUrl(videoList[index].url);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: index == 0 ? 0 : 10),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: bgColor,
                      border: Border.all(
                        width: 1.5,
                        color: borderColor,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      videoList[index].title,
                      style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
