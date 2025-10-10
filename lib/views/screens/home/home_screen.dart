import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/home_controller.dart';
import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/utils/app_sizes.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'components/ride_list.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(3.14159), // flip vertically
            child: CustomPaint(
              size: const Size(double.infinity, 240),
              painter: BackgroundPainter(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace(0.01.sh),

              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Find a Trip",
                    style: TextStyle(
                      fontSize: FontSizes.largeFontSize(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.notifications,
                    size: AppWidgetSizes.mediumIconSize(),
                    color: AppColors.backButtonColors,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Search Fields
              Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: controller.pickupController,
                      hintText: "Pickup City",
                      onChanged: (_) =>
                          controller.filterRides(controller.rides),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: controller.dropController,
                      hintText: "Drop City",
                      onChanged: (_) =>
                          controller.filterRides(controller.rides),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /// Date & Clear Button
              Row(
                children: [
                  SizedBox(
                    width: 0.48.sw,
                    child: CommonTextFieldWidget(
                      controller: controller.dateController,
                      readOnly: true,
                      hintText: "Departure Date",
                      onTap: () => controller.pickDepartureDate(context),
                    ),
                  ),
                  hSpace(8),
                  SizedBox(
                    width: 0.26.sw,
                    height: ProfileSizes.searchButtonHeight(),
                    child: ExpandedButton(
                      btnColor: AppColors.backButtonColors,
                      showBorder: true,
                      borderColor: AppColors.lightGrey,
                      btnTxtColor: AppColors.whiteColor,
                      txtSize: FontSizes.mediumFontSize(),
                      title: "Clear",
                      roundCorner: 10,
                      onTap: controller.clearTextFields,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Trip List
              Expanded(
                child: StreamBuilder<List<Ride>>(
                  stream: controller.rideRepository.getAllRides(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No trips available"));
                    }

                    controller.rides.value = snapshot.data!;
                    controller.filterRides(controller.rides);

                    return Obx(() {
                      if (controller.filteredRides.isEmpty) {
                        return const Center(
                          child: Text("No trips found for your search"),
                        );
                      }
                      return RideListView(rides: controller.filteredRides);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
