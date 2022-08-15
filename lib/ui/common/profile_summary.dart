import 'package:flutter/material.dart';
import 'package:levels/model/profiles.dart';
import 'package:levels/services/firebase_service.dart';
import 'package:levels/ui/common/separator.dart';
import 'package:levels/ui/detail/detail_page.dart';
import 'package:levels/ui/text_style.dart';

class ProfileSummary extends StatelessWidget {
  final Profile profile;
  final bool horizontal;
  final bool peopleCard;

  const ProfileSummary(this.profile, this.peopleCard, {this.horizontal = true});

  const ProfileSummary.vertical(this.profile, this.peopleCard)
      : horizontal = false;

  @override
  Widget build(BuildContext context) {
    final ProfileThumbnail = Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Hero(
        tag: "Profile-hero-${profile.id}",
        child: Image(
          image: AssetImage(profile.image),
          height: 92.0,
          width: 92.0,
        ),
      ),
    );

    Widget _ProfileValue({String? text, String? value, IconData? icon}) {
      return Container(
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Icon(
            icon,
            color: const Color(0xffb6b2df),
            size: 20,
          ),
          Text(text!, style: Style.smallTextStyle),
          // new Image.asset(image!, height: 12.0),
          Container(width: 8.0),
          Text(
              icon == Icons.numbers
                  ? double.parse(value!).toInt().toString()
                  : double.parse(value!).toInt().toString() + " %",
              style: Style.titleTextStyle),
        ]),
      );
    }

    final ProfileCardContent = Container(
      margin: EdgeInsets.fromLTRB(
          horizontal ? 50.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 4.0),
          Text(profile.name, style: Style.titleTextStyle),
          Container(height: 10.0),
          if (peopleCard)
            Row(
              children: [
                Expanded(
                    flex: (Profile.data["mkid"]!.toDouble() +
                            Profile.data["fkid"]!.toDouble())
                        .toInt(),
                    child: Container(
                        height: 4, color: Colors.pink, child: const Text("")

                        // child:Text("Kids")
                        )),
                Expanded(
                    flex: (Profile.data["myoung"]!.toDouble() +
                            Profile.data["fyoung"]!.toDouble())
                        .toInt(),
                    child: Container(
                        height: 4, color: Colors.blue, child: const Text(""))),
                Expanded(
                    flex: (Profile.data["fadult"]! +
                            Profile.data["madult"]!.toDouble())
                        .toInt(),
                    child: Container(
                        height: 4, color: Colors.black, child: const Text("")

                        // child:Text("Adults",)
                        )),
                Expanded(
                    flex: (Profile.data["mold"]!.toDouble() +
                            Profile.data["fold"]!.toDouble())
                        .toInt(),
                    child: Container(
                        height: 4, color: Colors.brown, child: const Text("")))
              ],
            ),
          if (peopleCard)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    "Kids:" +
                        ((Profile.data["mkid"]!.toDouble() +
                                    Profile.data["fkid"]!.toDouble())
                                .toInt())
                            .toString() +
                        "%",
                    style: const TextStyle(color: Colors.pink)),
                Text(
                    "Youth:" +
                        ((Profile.data["fyoung"]!.toDouble() +
                                    Profile.data["myoung"]!.toDouble())
                                .toInt())
                            .toString() +
                        "%",
                    style: const TextStyle(color: Colors.blue)),
                Text(
                    "Adult:" +
                        ((Profile.data["madult"]!.toDouble() +
                                    Profile.data["fadult"]!.toDouble())
                                .toInt())
                            .toString() +
                        "%",
                    style: const TextStyle(color: Colors.black)),
                Text(
                    "Old:" +
                        ((Profile.data["mold"]!.toDouble() +
                                    Profile.data["fold"]!.toDouble())
                                .toInt())
                            .toString() +
                        "%",
                    style: const TextStyle(color: Colors.brown)),
              ],
            ),

          // new Text(horizontal==false?profile.description:"", style: Style.commonTextStyle),
          if (horizontal == false) Separator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: horizontal ? 1 : 0,
                child: _ProfileValue(
                    text: horizontal == false ? "Number: " : "",
                    value: ((Profile.data[profile.nname]! *
                                    Profile.data["total_persons"]!)
                                .toDouble() /
                            100)
                        .toString(),
                    icon: Icons.numbers),
              ),
              if (peopleCard == false)
                Expanded(
                    flex: horizontal ? 1 : 0,
                    child: _ProfileValue(
                        text: horizontal == false ? "Percentage: " : "",
                        value: Profile.data[profile.nname]!.toInt().toString(),
                        icon: Icons.percent))
            ],
          ),
        ],
      ),
    );

    final ProfileCard = Container(
      child: ProfileCardContent,
      height: horizontal ? 124.0 : 154.0,
      margin: horizontal
          ? const EdgeInsets.only(left: 46.0)
          : const EdgeInsets.only(top: 50.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return GestureDetector(
        onTap: horizontal
            ? () async {
                FirestoreService fs = FirestoreService();
                FirestoreService.days =
                    await fs.getDays(FirestoreService.gadget);
                print(FirestoreService.days);
                FirestoreService.selectedDay =
                    FirestoreService.days[FirestoreService.days.length - 1];
                Profile.hourLine = await fs.getDayHours(
                    FirestoreService.gadget,
                    FirestoreService.days[FirestoreService.days.length - 1],
                    profile.nname);
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => DetailPage(profile: profile),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                  ),
                );
              }
            : null,
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 24.0,
          ),
          child: Stack(
            children: <Widget>[
              ProfileCard,
              ProfileThumbnail,
            ],
          ),
        ));
  }
}
