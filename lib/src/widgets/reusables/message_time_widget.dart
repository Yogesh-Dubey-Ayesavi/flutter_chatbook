part of '../../../flutter_chatbook.dart';

class WhatsAppMessageWidget extends StatelessWidget {
  final Message message;

  const WhatsAppMessageWidget(
    this.message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return receiptWidget;
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
        return const Icon(Icons.done_all, color: Color(0xffFCD8DC), size: 15);
      case DeliveryStatus.read:
        return const Icon(Icons.done_all, color: Colors.blue, size: 15);
      case DeliveryStatus.undelivered:
        return const Icon(Icons.check, color: Color(0xffFCD8DC), size: 15);
      case DeliveryStatus.pending:
        return const Icon(Icons.schedule, color: Color(0xffFCD8DC), size: 15);
      default:
        return const Icon(Icons.check, color: Colors.blue);
    }
  }
}
