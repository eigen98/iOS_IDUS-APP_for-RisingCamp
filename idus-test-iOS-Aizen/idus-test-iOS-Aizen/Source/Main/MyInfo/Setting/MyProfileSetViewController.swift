//
//  MyProfileSetViewController.swift
//  idus-test-iOS-Aizen
//
//  Created by JeongMin Ko on 2022/03/27.
//

import UIKit

//내 계정 정보 (프로필 수정)
class MyProfileSetViewController: BaseViewController {

    //데이터 매니저
    let dataManager = ProfileDataManager()
    //이전 뷰에서 받아올 유저 정보
    var userData : ProfileResponse? = nil
    
    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var phoneText: UILabel!
    
    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var birthText: UILabel!
    
    @IBOutlet weak var womanBtn: UIButton!
    
    @IBOutlet weak var manBtn: UIButton!
    
    var genderStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //성별 정보 불러오기
        genderStatus = userData?.result?.gender ?? 0
        //이름 정보
        nameText.text = userData?.result?.name
        emailText.text = userData?.result?.email
        phoneText.text = userData?.result?.phone
        birthText.text = ""
        initCheckboxGender(gender: userData?.result?.gender ?? 0 )
    }
    //성별 체크 메소드
    func initCheckboxGender(gender : Int){
        if gender == 0 {
            womanBtn.setImage(UIImage(systemName: "record.circle"), for: .normal)
            manBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            self.genderStatus = 0
        }else if gender == 1{
            manBtn.setImage(UIImage(systemName: "record.circle"), for: .normal)
            womanBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            self.genderStatus = 1
        }
    }
    
    @IBAction func tapWomenBtn(_ sender: UIButton) {
        initCheckboxGender(gender: 0)
        var request = ProfilePatchRequest(email: nil, name: nil, birthday: nil, gender: 0, phone: nil, recipient: nil, recipientPhone: nil, address: nil, profileImg: nil)
        self.dataManager.patchUserProfile(request, delegate: self)
        
    }
    
    @IBAction func tapManBtn(_ sender: UIButton) {
        initCheckboxGender(gender: 1)
        var request = ProfilePatchRequest(email: nil, name: nil, birthday: nil, gender: 1, phone: nil, recipient: nil, recipientPhone: nil, address: nil, profileImg: nil)
        self.dataManager.patchUserProfile(request, delegate: self)
        
    }
    
    //패치후 화면 업데이트
    func updateMyAccount(userData : ProfileResponse){
        self.userData = userData
        //성별 정보 불러오기
        genderStatus = userData.result?.gender ?? 0
        //이름 정보
        nameText.text = userData.result?.name
        emailText.text = userData.result?.email
        phoneText.text = userData.result?.phone
        birthText.text = "\(String(describing: userData.result?.birthday))"
        //initCheckboxGender(gender: userData.result?.gender ?? 0 )
    }
    @IBAction func changePhoneBtn(_ sender: UIButton) {
        presentEmailAlert(type: "전화번호 변경" ,title: "변경하기", message: "아이디어스 계정 연동 전화번호를 입력해주세요", holder: nil, isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            
        })
        
        
//        self.presentAlert(title: "전화번호 인증", message: "아이디어스 계정 연동 전화번호를 입력해주세요", isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
//
//        })
    }
    
    // MARK: 취소와 확인, 입력창이 뜨는 UIAlertController
    func presentEmailAlert(type : String, title: String, message: String? = nil, holder : String?,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
    
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        alert.addTextField()
        
        
        
        let actionDone = UIAlertAction(title: "확인", style: .default, handler: {result in
            let inputText = alert.textFields?.first?.text
            print("변경할 이메일은 \(inputText)")
            
            var request = ProfilePatchRequest(email: inputText, name: nil, birthday: nil, gender: nil, phone: nil, recipient: nil, recipientPhone: nil, address: nil, profileImg: nil)
            
            if type == "전화번호 변경"{
                request = ProfilePatchRequest(email: nil, name: nil, birthday: nil, gender: nil, phone: inputText, recipient: nil, recipientPhone: nil, address: nil, profileImg: nil)
            }
            self.dataManager.patchUserProfile(request, delegate: self)
           
        })
        
        alert.addAction(actionDone)
        
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //이메일 변경하기
    @IBAction func changeEmailBtn(_ sender: UIButton) {
        presentEmailAlert(type: "이메일 변경", title: "변경하기", message: "\(self.userData?.result?.email ?? "")에서 변경할 이메일을 입력해주세요", holder: nil, isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            
        })
        
    }
   

}


struct EmailChangeRequest : Codable{
    var email : String
    
}
