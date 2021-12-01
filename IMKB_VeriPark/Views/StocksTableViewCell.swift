
import UIKit
import CryptoSwift

class StocksTableViewCell: UITableViewCell {
    
    static let identifier = "StocksTableViewCell"
    
    private var aesKey: String? {
        return UserDefaults.standard.string(forKey: "aesKey")
    }
    
    private var aesIV: String? {
        return UserDefaults.standard.string(forKey: "aesIV")
    }
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let isDownUp: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let bidLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let offerLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(symbolLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(differenceLabel)
        stackView.addArrangedSubview(volumeLabel)
        stackView.addArrangedSubview(bidLabel)
        stackView.addArrangedSubview(offerLabel)
        stackView.addArrangedSubview(isDownUp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = contentView.bounds
    }
    
    func configure(stock: Stock?) {
        guard let stock = stock else { return }
        symbolLabel.text = stock.symbol
            //AesCryptoManager.shared.aesDecrypt(symbol: stock.symbol)
        priceLabel.text = String(stock.price)
        differenceLabel.text = String(stock.difference)
        volumeLabel.text = String(stock.volume)
        bidLabel.text = String(stock.bid)
        offerLabel.text = String(stock.offer)
        
        if stock.isUp {
            isDownUp.image = UIImage(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16, weight: .regular)))
            isDownUp.tintColor = .systemGreen
        }else {
            isDownUp.image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 16, weight: .regular)))
            isDownUp.tintColor = .systemRed
        }
    }
}

