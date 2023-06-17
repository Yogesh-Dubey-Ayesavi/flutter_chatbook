part of '../../../flutter_chatbook.dart';

class WhatsAppMessageWidget extends StatelessWidget {
  final Message message;

  const WhatsAppMessageWidget(
    this.message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, top: 2), child: receiptWidget);
  }

  Widget get receiptWidget => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              DateTime.fromMillisecondsSinceEpoch(message.createdAt)
                  .getTimeFromDateTime,
              style: const TextStyle(color: Color(0xffFCD8DC), fontSize: 11)),
          const SizedBox(width: 5),
          getReceipt()
        ],
      );

  Widget getReceipt() {
    switch (message.status) {
      case DeliveryStatus.delivered:
        return const Row(children: [
          Icon(Icons.check_circle_outlined, color: Color(0xffFCD8DC), size: 10),
          Icon(Icons.check_circle_outlined, color: Color(0xffFCD8DC), size: 10),
        ]);
      case DeliveryStatus.read:
        return Row(children: [
          Icon(Icons.check_circle, color: Color(0xffFCD8DC), size: 11),
          Icon(Icons.check_circle, color: Color(0xffFCD8DC), size: 11),
        ]);
      case DeliveryStatus.undelivered:
        return const Icon(Icons.check, color: Color(0xffFCD8DC), size: 15);
      case DeliveryStatus.pending:
        return const Icon(Icons.schedule, color: Color(0xffFCD8DC), size: 15);
      default:
        return const Icon(Icons.check, color: Colors.blue);
    }
  }
}
