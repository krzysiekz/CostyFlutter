import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app_localizations.dart';
import '../../../data/models/project.dart';
import '../../../style_constants.dart';
import '../../bloc/bloc.dart';
import '../item/report_entry_list_item.dart';
import '../utilities/dialog_utilities.dart';

class ReportPage extends StatefulWidget {
  final Project project;

  const ReportPage({Key key, @required this.project}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    BlocProvider.of<ReportBloc>(context).add(GetReportEvent(widget.project));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRect(child: buildHeader(context)),
        Expanded(child: buildBody()),
      ],
    );
  }

  Stack buildHeader(BuildContext context) {
    return Stack(
      children: [
        buildHeaderBackground(),
        Positioned(top: 40, left: 20, child: buildHeaderDescription(context)),
        Positioned(
          top: 30,
          right: 10,
          child: SvgPicture.asset('assets/images/social.svg',
              semanticsLabel: 'Share image'),
        ),
      ],
    );
  }

  Transform buildHeaderBackground() {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Transform.scale(
        scale: 1.2,
        child: Stack(
          children: [
            buildBottomCard(),
            buildTopCard(),
          ],
        ),
      ),
    );
  }

  Transform buildTopCard() {
    return Transform.translate(
      offset: const Offset(30, 0),
      child: Transform.rotate(
        angle: -15 * pi / 180,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              gradient: StyleConstants.primaryGradient),
        ),
      ),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: StyleConstants.secondaryGradient),
      ),
    );
  }

  Widget buildHeaderDescription(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 15,
      children: [
        Text(
            AppLocalizations.of(context)
                .translate('project_details_page_report'),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: StyleConstants.primaryFontWeight,
              color: StyleConstants.primaryTextColor,
              fontSize: StyleConstants.primaryTextSize,
            )),
        Text(AppLocalizations.of(context).translate('report_page_description'),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: StyleConstants.secondaryFontWeight,
              color: StyleConstants.primaryTextColor,
              fontSize: StyleConstants.secondaryTextSize,
            )),
        FlatButton(
          onPressed: () => _shareReport(context, widget.project),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          color: Colors.white,
          child: Text(AppLocalizations.of(context).translate('share'),
              style: const TextStyle(
                fontWeight: StyleConstants.buttonsTextFontWeight,
                color: Colors.black,
                fontSize: StyleConstants.buttonsTextSize,
              )),
        ),
      ],
    );
  }

  BlocBuilder<ReportBloc, ReportState> buildBody() {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (BuildContext context, ReportState state) {
        if (state is ReportEmpty) {
          return Text(
              AppLocalizations.of(context).translate('report_page_no_report'));
        } else if (state is ReportLoaded) {
          if (state.report != null && state.report.entries.isEmpty) {
            return Text(AppLocalizations.of(context)
                .translate('report_page_no_report'));
          } else if (state.report != null) {
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemBuilder: (cts, index) {
                return ReportEntryListItem(
                    reportEntry: state.report.entries[index]);
              },
              itemCount: state.report.entries.length,
            );
          }
        } else if (state is ReportLoading) {
          return DialogUtilities.showLoadingIndicator(context);
        }
        return Container();
      },
    );
  }

  void _shareReport(BuildContext ctx, Project project) {
    BlocProvider.of<ReportBloc>(context).add(ShareReportEvent(project, ctx));
    BlocProvider.of<ReportBloc>(context).add(GetReportEvent(project));
  }
}
