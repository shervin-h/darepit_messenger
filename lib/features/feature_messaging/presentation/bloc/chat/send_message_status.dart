abstract class SendMessageStatus {}

class SendMessageInitialStatus extends SendMessageStatus {}

class SendMessageLoadingStatus extends SendMessageStatus {}

class SendMessageCompletedStatus extends SendMessageStatus {}

class SendMessageErrorStatus extends SendMessageStatus {
  final String errorMessage;
  SendMessageErrorStatus(this.errorMessage);
}