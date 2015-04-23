//
//  LoginViewController.m
//  EverHelp
//
//  Created by Chubin OU on 3/28/15.
//  Copyright (c) 2015 Chubin OU. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self. navigationController setNavigationBarHidden:YES];
    self.userName.delegate = self;
    self.userPassword.delegate = self;
    /*PFUser *currentUser = [PFUser currentUser];
    if (currentUser){
        [glb_user setUser:currentUser];
        PFQuery *query = [PFQuery queryWithClassName:@"Note"];
        [query whereKey:@"username" equalTo:currentUser[@"username"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error" message:@"Network Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                for (PFObject *ob in objects) {
                    [glb_user addNote:ob];
                }
                [SVProgressHUD dismiss];
                [self performSegueWithIdentifier:@"logintoMapView" sender:self];
            }
        }];

    }*/
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



- (IBAction)onSignIn:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging in ..."
                         maskType:SVProgressHUDMaskTypeNone];
    [PFUser logInWithUsernameInBackground:_userName.text password:_userPassword.text target:self selector:@selector(handleUserLogin:error:)];
}

- (IBAction)onSignUp:(id)sender {
    [SVProgressHUD showWithStatus:@"Creating Account.."];
    [self registerUserToParse];
}

- (void)handleUserLogin:(PFUser *)user error:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    if (error.code == 101) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"You must enter the correct login & password to register or login, try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }else if (error.code == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Network error, would you like to work offline?"
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        
        [alert show];
    }
    else if (!error)
    {
        if (user) {
            [SVProgressHUD showWithStatus:@"Loading User Informations.."];
            PFUser *pfuser = [PFUser currentUser];
            [glb_user setUser:pfuser];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            currentInstallation[@"user"]=pfuser;
            [currentInstallation saveInBackground];
            PFQuery *query = [PFQuery queryWithClassName:@"Note"];
            [query whereKey:@"username" equalTo:pfuser[@"username"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Error" message:@"Network Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    for (PFObject *ob in objects) {
                        [glb_user addNote:ob];
                    }
                    [SVProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"logintoMapView" sender:self];
                }
            }];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"Incorrect user name and Password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)registerUserToParse
{
    PFUser *user = [PFUser user];
    user.username = _userName.text;
    user.password = _userPassword.text;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSelectorOnMainThread:@selector(signup_success) withObject:nil waitUntilDone:NO];
        } else {
            if (error.code == 100) { // network error
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Network error, would you like to work offline?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Yes"
                                                      otherButtonTitles:@"No", nil];
                [alert show];
                
            } else if ((error.code == 202) || (error.code == 203)) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You The email address is already taken by other user." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry, unknown error. Try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        [SVProgressHUD dismiss];
    }];
}

- (void)signup_success
{
    PFUser *pfuser = [PFUser currentUser];
    
    [pfuser save];
    
    [SVProgressHUD dismiss];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"Register Success!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end


