
import UIKit

final class DetailsInfoView: UIView {
    
    struct DetailsInfoViewVM {
        let isDown: Bool
        let isUp: Bool
        let bid: Float
        let channge: Float
        let count: Int
        let difference: Float
        let offer: Float
        let highest: Float
        let lowest: Float
        let maximum: Float
        let minimum: Float
        let price: Float
        let volume: Float
        let symbol: String
    }
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let sellLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let buyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "Değişim: "
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let dailyHighLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let dailyLowLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let highLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let lowLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let changeView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let changeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "chevron.up")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(leftStackView)
        addSubview(rightStackView)
        leftStackView.addArrangedSubview(symbolLabel)
        leftStackView.addArrangedSubview(priceLabel)
        leftStackView.addArrangedSubview(differenceLabel)
        leftStackView.addArrangedSubview(volumeLabel)
        leftStackView.addArrangedSubview(buyLabel)
        leftStackView.addArrangedSubview(sellLabel)
        
        rightStackView.addArrangedSubview(dailyLowLabel)
        rightStackView.addArrangedSubview(dailyHighLabel)
        rightStackView.addArrangedSubview(totalLabel)
        rightStackView.addArrangedSubview(highLabel)
        rightStackView.addArrangedSubview(lowLabel)
        rightStackView.addArrangedSubview(changeLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftStackView.frame = CGRect(
            x: 10,
            y: 0,
            width: width/2-10,
            height: height
        )
        rightStackView.frame = CGRect(
            x: leftStackView.right,
            y: 0,
            width: width/2-10,
            height: height
        )
    }
    
    func configure(with viewModel: DetailsInfoViewVM) {
        symbolLabel.text = "Sembol: " + viewModel.symbol.aesDecrypt()
        priceLabel.text = "Fiyat: " + String(viewModel.price)
        differenceLabel.text = "% Fark: " + String(viewModel.difference)
        volumeLabel.text = "Hacim: " + String(viewModel.volume)
        buyLabel.text = "Alış: " + String(viewModel.bid)
        sellLabel.text = "Satış: " + String(viewModel.offer)
        dailyLowLabel.text = "Günlük Düşük: " + String(viewModel.lowest)
        dailyHighLabel.text = "Günlük Yüksek: " +  String(viewModel.highest)
        totalLabel.text = "Adet: " + String(viewModel.count)
        highLabel.text = "Tavan: " + String(viewModel.maximum)
        lowLabel.text = "Taban: " + String(viewModel.minimum)
        
        if viewModel.isUp {
            changeLabel.addImageWith(name: "up", behindText: true)
        } else {
            changeLabel.addImageWith(name: "down", behindText: true)
        }
    }
}
