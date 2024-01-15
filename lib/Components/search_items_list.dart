import 'package:flutter/material.dart';
import 'package:untitled2/Components/items.dart';


class SearchedSpacedItemsList extends StatelessWidget {
  final List<Map<String?, dynamic>> searchDetailsList;
  final int usrId;

  const SearchedSpacedItemsList({
    Key? key,
    required this.searchDetailsList,
    required this.usrId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchDetailsList.length,
      itemBuilder: (context, index) {
        return LikeCard(
          designDetails: searchDetailsList[index],
          loggedInUserId: usrId,
        );
      },
    );
  }
}