import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  NotificationInfos model;

  NotificationItem(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: !model.isReaded ? getColor('#2224cbe5') : Colors.white,
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            placeholder: (context, url) => Icon(
              Icons.account_circle,
              size: 24,
              color: Colors.grey,
            ),
            errorWidget: (context, url, erro) {
              return Icon(
                Icons.account_circle,
                size: 24,
                color: Colors.grey,
              );
            },
            imageUrl: model.senderAvatar ?? "",
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              );
            },
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                            text: model.senderName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                        TextSpan(text: ' ${model?.messageType ?? ""}'),
                        // TextSpan(
                        //     text: ' ${model.message?? ""}',
                        //     style: TextStyle(color: Colors.black))
                      ]),
                ),
                Html(
                  data: ' ${model.message ?? ""}',
                ),
                Text(
                    '${convertTimeStampToHumanDate(model.created, Constant.ddMMyyyyHHmm)}')
              ],
            ),
          )
        ],
      ),
    );
  }
}

