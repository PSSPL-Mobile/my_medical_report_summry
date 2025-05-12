import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_medical_report_summry/constants.dart';

/// Name : TipsScreen
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Displays a list of personalized health tips with a header and icon-marked cards.
class TipsScreen extends StatelessWidget {
  final List<String> tips; // List of health tip strings to display.

  const TipsScreen({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    // Section: Main Layout
    // Builds a column with a header and a list of tips.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section: Header
        // Displays the "Personalized Health Tips" title with an icon.
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(Icons.favorite, color: Colors.lightGreen),
              SizedBox(width: 8),
              Text(
                'Personalized Health Tips',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),

        // Section: Tips List
        // Displays each tip in a card with an SVG icon and text.
        ListView.builder(
          shrinkWrap: true, // Ensure the ListView takes only the space it needs.
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling to prevent nested scroll issues.
          itemCount: tips.length,
          itemBuilder: (context, index) {
            return Card(
              color: AppConstants.tipCardColor, // Soft background color for the tip card (e.g., soft mint blue).
              margin: const EdgeInsets.symmetric(vertical: 6), // Vertical spacing between cards.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners for a softer look.
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SVG icon to mark each tip.
                    Container(
                      margin: const EdgeInsets.only(top: 5), // Align the icon vertically with the text.
                      child: SvgPicture.asset(
                        'assets/icons/icon_mark.svg',
                        width: 15,
                        height: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tip text, expanded to fill available space.
                    Expanded(
                      child: Text(
                        tips[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}