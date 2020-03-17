import 'package:costy/data/models/project.dart';
import 'package:costy/presentation/bloc/bloc.dart';
import 'package:costy/presentation/widgets/item/report_entry_list_item.dart';
import 'package:costy/presentation/widgets/utilities/dialog_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';

class ReportPage extends StatefulWidget {
  final Project project;

  ReportPage({Key key, @required this.project}) : super(key: key);

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
    return BlocBuilder<ReportBloc, ReportState>(
      bloc: BlocProvider.of<ReportBloc>(context),
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
              padding: const EdgeInsets.all(25),
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
}
