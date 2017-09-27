# KSXYSwitchView
一个酷炫的弹出式，快捷选择菜单

使用简单，一个函数全部搞定。

使用pods管理

pod 'KSXYSwitchView'

//本地路径  图片名称
    //@"person_info.png", @"make_call.png", @"make_audio_call.png", @"make_video_call.png"      
    
    
        [KSXYSwitchView showInView:self.view images:@[@"person_info.png", @"make_call.png", @"make_audio_call.png", @"make_video_call.png"] atPoint:point buttonClicked:^(NSInteger index) {
            if(index == 0) {
                NSLog(@"Click person button index = %ld", (long)index);
            } 
            else if(index == 1) {
                NSLog(@"Click call button index = %ld", (long)index);
            } 
            else if(index == 2) {
                NSLog(@"Click audio call button index = %ld", (long)index);
            } 
            else if(index == 3) {
                NSLog(@"Click video call button index = %ld", (long)index);
            }
         }];
