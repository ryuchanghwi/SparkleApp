//
//  HistoryTableViewCell.swift
//  Uni
//
//  Created by 김사랑 on 2023/07/14.
//

import UIKit
import Then
import SDSKit

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let gameDateLabel = UILabel().then {
//        $0.text = "23.06.20"
        $0.textColor = .gray400
        $0.font = SDSFont.body2.font
    }
    
    private let gameImageView = UIImageView().then {
        $0.backgroundColor = .gray200 //이미지 변경하기
        $0.layer.cornerRadius = 8
    }
    
    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .fillProportionally
    }
    
    private let gameNameLabel = UILabel().then {
//        $0.text = "대답 유도하기"
        $0.textColor = .gray600
        $0.font = SDSFont.body1.font
    }
    
    private let gameResultLabel = UILabel().then {
//        $0.text = "패배"
        $0.textColor = .lightBlue500
        $0.font = SDSFont.body2.font
    }
    
    private let nextImageView = UIImageView().then {
        $0.image = UIImage(named: "icChevron28")
    }
    
    // MARK: - UI Property
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setLayout()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setting
    
    private func setStyle() {
        self.backgroundColor = .white
    }
    
    private func setLayout() {
//        self.contentView.addSubview(self.gameDateLabel)
        [gameDateLabel, gameImageView, textStackView, nextImageView].forEach {
            self.contentView.addSubview($0)
        }
        [gameNameLabel, gameResultLabel].forEach {
            textStackView.addArrangedSubview($0)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        gameDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        gameImageView.snp.makeConstraints {
            $0.top.equalTo(gameDateLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(48)
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(gameDateLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(gameImageView.snp.trailing).offset(16)
        }
        
        nextImageView.snp.makeConstraints {
            $0.centerY.equalTo(gameImageView)
            $0.trailing.equalToSuperview()
        }
        
        
    }
    
    
    
    // MARK: - Action Helper
    
    // MARK: - Custom Method
    func configureCell() { // 내용을 붙여주는 함수
        gameDateLabel.text = "23.06.20"
        gameNameLabel.text = "대답 유도하기"
        gameResultLabel.text = "패배"
    }
    

}
