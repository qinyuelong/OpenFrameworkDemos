//
//  ViewController.m
//  GoogleProtobufDemo
//
//  Created by qinge on 2018/4/6.
//  Copyright © 2018年 qin. All rights reserved.
//

#import "ViewController.h"
#import "Person.pbobjc.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *person = [[Person alloc] init];
    person.personName = @"xiaoming";
    person.personGender = @"Male";
    person.personMessage = @"Test";
    
    NSData *data = [person data];
    
    Person *genPerson = [Person parseFromData:data error:nil];
    
    NSLog(@"%@", genPerson);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
