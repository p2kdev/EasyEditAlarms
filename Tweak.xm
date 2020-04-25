@interface MTAAlarmTableViewCell : UITableViewCell
  @property (nonatomic,assign,readwrite) BOOL isSleepAlarm;
@end

@interface MTAAlarmTableViewController
  - (void)showEditViewForRow:(long long)arg1;
  - (void)showSleepControlsView;
@end

%hook MTAAlarmTableViewController

  - (id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2
  {
      MTAAlarmTableViewCell *cell = %orig;

      UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAlarmTap:)];
      tapRecognizer.numberOfTapsRequired = 1;
      [cell addGestureRecognizer:tapRecognizer];
      [cell setUserInteractionEnabled:YES];

      if ([cell respondsToSelector:@selector(isSleepAlarm)])
      {
        if (cell.isSleepAlarm)
          [cell setTag:-1];
        else
          [cell setTag:arg2.row];
      }
      else
        [cell setTag:arg2.row];

      return cell;
   }

 %new

   -(void)handleAlarmTap:(UITapGestureRecognizer *)sender
   {

    if (sender.state == UIGestureRecognizerStateEnded)
    {
      if (sender.view.tag == -1)
        [self showSleepControlsView];
      else
       [self showEditViewForRow:sender.view.tag];
    }

   }

%end
