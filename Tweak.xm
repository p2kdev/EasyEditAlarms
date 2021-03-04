@interface MTAAlarmTableViewCell : UITableViewCell
  @property (nonatomic,assign,readwrite) BOOL isSleepAlarm;
@end

@interface MTAAlarmTableViewController
  - (void)showEditViewForRow:(long long)arg1;
  - (void)showSleepControlsView;
  - (void)showSleepView;
@end

%hook MTAAlarmTableViewController

  - (id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2
  {
      UITableViewCell* cell = %orig;

      [cell setTag:-3];

      if ([cell isKindOfClass:NSClassFromString(@"MTAAlarmTableViewCell")])
      {
        if ([cell respondsToSelector:@selector(isSleepAlarm)])
        {
          if (((MTAAlarmTableViewCell*)cell).isSleepAlarm)
            [cell setTag:-1]; //iOS13
          else
            [cell setTag:arg2.row];
        }
        else
          [cell setTag:arg2.row];
      }
      else if ([cell isKindOfClass:NSClassFromString(@"MTASleepAlarmTableViewCell")])
        [cell setTag:-2]; //iOS14

      //Only add gesture recognizer if it's a know cell type
      if (cell.tag > -3)
      {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAlarmTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [cell addGestureRecognizer:tapRecognizer];
        [cell setUserInteractionEnabled:YES];
      }

      return cell;
   }

 %new

   -(void)handleAlarmTap:(UITapGestureRecognizer *)sender
   {

    if (sender.state == UIGestureRecognizerStateEnded)
    {
      if (sender.view.tag == -1)
        [self showSleepControlsView]; //iOS13
      else if (sender.view.tag == -2)
        [self showSleepView]; //iOS14
      else
       [self showEditViewForRow:sender.view.tag];
    }

   }

%end
