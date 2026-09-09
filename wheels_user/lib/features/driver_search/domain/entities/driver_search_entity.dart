class DriverSearchEntity {
  final String statusTitle;
  final String statusSubtitle;
  final String estimatedConfirmationText;
  final String orderTime;
  final String scanRadiusText;
  final int activeStepIndex;

  const DriverSearchEntity({
    required this.statusTitle,
    required this.statusSubtitle,
    required this.estimatedConfirmationText,
    required this.orderTime,
    required this.scanRadiusText,
    required this.activeStepIndex,
  });
}
