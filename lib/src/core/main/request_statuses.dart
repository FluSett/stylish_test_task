enum RequestStatuses {
  processing,
  idle,
  error;

  bool get isProcessing => this == RequestStatuses.processing;

  bool get isIdle => this == RequestStatuses.idle;

  bool get isError => this == RequestStatuses.error;
}
