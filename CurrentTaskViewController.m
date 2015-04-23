//
//  CurrentTaskViewController.m
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "CurrentTaskViewController.h"
#import <Parse/Parse.h>


@interface CurrentTaskViewController ()

@end

@implementation CurrentTaskViewController{
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.completeButton setHidden:YES];
    self.inputText.delegate = self;
    self.chatHistory = [[NSMutableArray alloc]init];
    self.chatTable.delegate = self;
    self.chatTable.dataSource = self;
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"returnButton.png"] forState:UIControlStateNormal];
    [self.backButton setTitle:nil forState:UIControlStateNormal];
    [self.completeButton setBackgroundImage:[UIImage imageNamed:@"completeButton"] forState:UIControlStateNormal];
    [self.completeButton setTitle:nil forState:UIControlStateNormal];

    PFQuery *query1 = [PFQuery queryWithClassName:@"Note"];
    [query1 whereKey:@"status" equalTo:@"accepted"];
    [query1 whereKey:@"helpername" equalTo:[glb_user getUserName]];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"%lu",(unsigned long)objects.count);
            if (objects.count>0){
                PFObject *ob = [objects firstObject];
                self.theotherusername = ob[@"username"];
                self.chatTitle.text = [NSString stringWithFormat:@"Chat with %@",self.theotherusername];
                self.role = @"helper";
                self.currentTask = ob;
                self.taskTitle.text = ob[@"title"];
                [self setupButtonForRole:self.role];
                [self fetchChat];
                [self startTimer];
            }
        }
    }];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Note"];
    [query2 whereKey:@"status" equalTo:@"accepted"];
    [query2 whereKey:@"username" equalTo:[glb_user getUserName]];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (objects.count>0){
                NSLog(@"%lu",(unsigned long)objects.count);
                PFObject *ob = [objects firstObject];
                self.theotherusername = ob[@"helpername"];
                self.chatTitle.text = [NSString stringWithFormat:@"Chat with %@",self.theotherusername];
                self.role = @"poster";
                self.currentTask = ob;
                self.taskTitle.text = ob[@"title"];
                [self setupButtonForRole:self.role];
                [self fetchChat];
                [self startTimer];
            }
        }
    }];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBack:(id)sender {
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[MapViewController class]]){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
}

- (IBAction)onSent:(id)sender {
    PFObject *chat = [PFObject objectWithClassName:@"Chat"];
    chat[@"sender"] = glb_user.username;
    chat[@"receiver"] = self.theotherusername;
    chat[@"content"] = self.inputText.text;
    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            self.inputText.text = @"";
            [self fetchChat];
        }
    }];
}

- (IBAction)onComplete:(id)sender {
    self.currentTask[@"status"] = @"completed";
    [self.currentTask saveInBackground];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Chat"];
    [query1 whereKey:@"sender" equalTo:[glb_user getUserName]];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Chat"];
    [query2 whereKey:@"sender" equalTo:self.theotherusername];
    NSArray *queryArray = [[NSArray alloc]initWithObjects:query1,query2, nil];
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:queryArray];
    NSLog(@"Combined Query");
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            for (PFObject *ob in objects){
                [ob deleteInBackground];
            }
        }
    }];
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[MapViewController class]]){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
}

- (void)fetchChat{
    if ([self.role isEqualToString:@"helper"]){
        if ([self.currentTask[@"status"] isEqualToString:@"completed"]){
            NSArray *viewControllers = [[self navigationController] viewControllers];
            for( int i=0;i<[viewControllers count];i++){
                id obj=[viewControllers objectAtIndex:i];
                if([obj isKindOfClass:[MapViewController class]]){
                    [[self navigationController] popToViewController:obj animated:YES];
                    return;
                }
            }
        }
    }
    PFQuery *query1 = [PFQuery queryWithClassName:@"Chat"];
    [query1 whereKey:@"sender" equalTo:glb_user.username];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Chat"];
    [query2 whereKey:@"sender" equalTo:self.theotherusername];
    NSArray *queryArray = [[NSArray alloc]initWithObjects:query1,query2, nil];
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:queryArray];
    [combinedQuery orderByAscending:@"createdAt"];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            self.chatHistory = [NSMutableArray arrayWithArray:objects];
            [self.chatTable reloadData];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.chatHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    for(UIView* subview in [cell subviews])
        [subview removeFromSuperview];
    PFObject *chat = [self.chatHistory objectAtIndex:indexPath.row];
    if ([glb_user.username isEqualToString:chat[@"sender"]]){
        UILabel *conversation = [[UILabel alloc]initWithFrame:CGRectMake(160,8,120,28)];
        conversation.text = [NSString stringWithFormat:@"%@      ",chat[@"content"]];
        conversation.textAlignment = NSTextAlignmentRight;
        conversation.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(136.0/255.0) blue:0.0 alpha:1];
        conversation.layer.cornerRadius = 5;
        conversation.layer.masksToBounds = YES;
        [cell addSubview:conversation];
    } else {
        UILabel *conversation = [[UILabel alloc]initWithFrame:CGRectMake(10,8,120,28)];
        conversation.text = [NSString stringWithFormat:@"  %@",chat[@"content"]];
        conversation.textAlignment = NSTextAlignmentLeft;
        conversation.backgroundColor = [UIColor colorWithRed:0.0 green:(153.0/255.0) blue:(204.0/255.0) alpha:1];
        conversation.layer.cornerRadius = 5;
        conversation.layer.masksToBounds = YES;
        [cell addSubview:conversation];
    }
    return cell;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma Periodically Fetch From Parse
dispatch_source_t aCreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}
- (void)startTimer
{
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToFire = 3.0f;
    
    _timer = aCreateDispatchTimer(secondsToFire, dispatch_get_main_queue(), ^{
        // Do something
        [self fetchChat];
    });
}

- (void)cancelTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        // Remove this if you are on a Deployment Target of iOS6 or OSX 10.8 and above
        _timer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidDisappear:(BOOL)animated{
    [self cancelTimer];
}

- (void)setupButtonForRole:(NSString *)role{
    if ([role isEqualToString:@"helper"]){
        [self.completeButton setHidden:YES];
        self.completeButton.enabled = NO;
        NSLog(@"Helper");
    } else {
        [self.completeButton setHidden:NO];
        self.completeButton.enabled = YES;
        NSLog(@"Poster");
    }
    
}
@end
