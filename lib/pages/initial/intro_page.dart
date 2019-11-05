import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Widget> dots = new List();
  Color colorDot = Color(0xFFE4E4E4), colorActiveDot = Color(0xFFEEAEFF);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      this.setState(() {});
    });
  }

  Widget buildPageContent(bgImage, txt1, txt2) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/' + bgImage),
              fit: BoxFit.cover)),
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          Text(
            txt1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              txt2,
              style: TextStyle(fontSize: 14.0, color: Color(0xFFEEAEFF)),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }

  List<Widget> renderListDots() {
    dots.clear();
    for (int i = 0; i < 3; i++) {
      Color currentColor;
      if (tabController.index == i) {
        currentColor = colorActiveDot;
      } else {
        currentColor = colorDot;
      }
      dots.add(renderDot(8, currentColor, i));
    }
    return dots;
  }

  Widget renderDot(double radius, Color color, int i) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          tabController.index = i;
        },
        child: Container(
          child: CircleAvatar(
            backgroundColor: color,
            radius: radius,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final state = Provider.of<AppSettings>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            TabBarView(
              // physics: ScrollPhysics(),
              controller: tabController,
              children: <Widget>[
                buildPageContent('onboarding1.png', 'Binaural beats',
                    'Search for what type of music you want.\nEg: Relaxation, Calm etc'),
                buildPageContent('onboarding2.png', 'Mental Calmness',
                    'Search the different categories of music you want'),
                buildPageContent('onboarding3.png', 'Meditate',
                    'Have a fun, find your needs.\nEnjoy the music'),
              ],
            ),
            Positioned(
              bottom: 25.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: renderListDots(),
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            Positioned(
              bottom: 25.0,
              right: 25.0,
              child: GestureDetector(
                onTap: () {
                  if (tabController.index != 2)
                    tabController.index++;
                  else {
                    // state.setfirstrun();
                    Navigator.pushReplacementNamed(context, 'login');
                  }

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginHome()),
                  // );
                },
                child: Text(
                  tabController.index != 2 ? 'NEXT' : 'Finish',
                  style: TextStyle(fontSize: 17, color: Color(0xFFEEAEFF)),
                ),
              ),
            ),
            Positioned(
              bottom: 25.0,
              left: 25.0,
              child: tabController.index == 2
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        // state.setfirstrun();
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: Text(
                        'SKIP',
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFFEEAEFF)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
