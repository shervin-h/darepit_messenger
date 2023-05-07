abstract class DeleteMessageStatus {}

class DeleteMessageInitialStatus extends DeleteMessageStatus {}

class DeleteMessageLoadingStatus extends DeleteMessageStatus {}

class DeleteMessageCompletedStatus extends DeleteMessageStatus {}

class DeleteMessageErrorStatus extends DeleteMessageStatus {
  final String errorMessage;
  DeleteMessageErrorStatus(this.errorMessage);
}