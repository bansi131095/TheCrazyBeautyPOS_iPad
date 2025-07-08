//
//  General_InfoVC.swift
//  TheCrazyBeautyPOS
//
//  Created by mini new on 04/07/25.
//

enum ColorApplyMode {
    case text
    case background
}

enum TextAlignmentType {
    case left
    case center
    case right
}

import UIKit

class General_InfoVC: UIViewController {

    var colorApplyMode: ColorApplyMode = .text
    
    @IBOutlet weak var txt_Aboutus: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func btn_Bold(_ sender: Any) {
        toggleBold(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Italic(_ sender: Any) {
        toggleItalic(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Underline(_ sender: Any) {
        toggleUnderline(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Strikethrough(_ sender: Any) {
        toggleStrikethrough(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Superscriptx²(_ sender: Any) {
//        toggleSuperscript(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Subscriptx₂(_ sender: Any) {
//        toggleSubscript(textView: txt_Aboutus)
    }
    
    @IBAction func btn_H1(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 1)
    }
    
    @IBAction func btn_H2(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 2)
    }
    
    @IBAction func btn_H3(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 3)
    }
    
    @IBAction func btn_H4(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 4)
    }
    
    @IBAction func btn_H5(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 5)
    }
    
    @IBAction func btn_H6(_ sender: Any) {
        applyHeading(textView: txt_Aboutus, level: 6)
    }
    
    @IBAction func btn_TextColor(_ sender: Any) {
        showColorPicker(mode: .text)
    }
    
    @IBAction func btn_TextBackgroundColor(_ sender: Any) {
        showColorPicker(mode: .background)
    }
    
    @IBAction func btn_indentButtonTapped(_ sender: UIButton) {
        increaseIndent(textView: txt_Aboutus)
    }
    
    @IBAction func btn_DecreaseIndentButtonTapped(_ sender: UIButton) {
        decreaseIndent(textView: txt_Aboutus)
    }
    
    @IBAction func btn_AlignRight(_ sender: UIButton) {
        applyTextAlignment(textView: txt_Aboutus, alignment: .left)
    }
    
    @IBAction func btn_AlignCenter(_ sender: UIButton) {
        applyTextAlignment(textView: txt_Aboutus, alignment: .center)
    }
    
    @IBAction func btn_AlignLeft(_ sender: UIButton) {
        applyTextAlignment(textView: txt_Aboutus, alignment: .right)
    }
    
    
    @IBAction func btn_Dot(_ sender: Any) {
        toggleBulletList(textView: txt_Aboutus)
    }
    
    @IBAction func btn_Number(_ sender: Any) {
        toggleNumberedList(textView: txt_Aboutus)
    }
    
    
    @IBAction func btn_99(_ sender: Any) {
    }
    
    
    @IBAction func btn_Image(_ sender: Any) {
    }
    
    
    @IBAction func btn_link(_ sender: Any) {
    }
    
    @IBAction func btn_Check(_ sender: Any) {
    }
    
    @IBAction func btn_Undo(_ sender: Any) {
    }
    
    @IBAction func btn_Redo(_ sender: Any) {
    }
    
    //MARK: - Bold
    func toggleBold(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            // ✅ If text is selected → toggle bold per portion
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentFont = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                var traits = currentFont.fontDescriptor.symbolicTraits

                if traits.contains(.traitBold) {
                    traits.remove(.traitBold)
                } else {
                    traits.insert(.traitBold)
                }

                if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                    let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                    mutableAttrText.addAttribute(.font, value: newFont, range: range)
                }
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            // ✅ No selection → toggle typing attributes for future text
            let currentFont = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            var traits = currentFont.fontDescriptor.symbolicTraits

            if traits.contains(.traitBold) {
                traits.remove(.traitBold)
            } else {
                traits.insert(.traitBold)
            }

            if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                textView.typingAttributes[.font] = newFont
            }
        }
    }
    
    //MARK: - Italic
    func toggleItalic(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentFont = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                var traits = currentFont.fontDescriptor.symbolicTraits

                if traits.contains(.traitItalic) {
                    traits.remove(.traitItalic)
                } else {
                    traits.insert(.traitItalic)
                }

                if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                    let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                    mutableAttrText.addAttribute(.font, value: newFont, range: range)
                }
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            let currentFont = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            var traits = currentFont.fontDescriptor.symbolicTraits

            if traits.contains(.traitItalic) {
                traits.remove(.traitItalic)
            } else {
                traits.insert(.traitItalic)
            }

            if let newDescriptor = currentFont.fontDescriptor.withSymbolicTraits(traits) {
                let newFont = UIFont(descriptor: newDescriptor, size: currentFont.pointSize)
                textView.typingAttributes[.font] = newFont
            }
        }
    }

    //MARK: - Underline
    func toggleUnderline(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentUnderline = attributes[.underlineStyle] as? Int ?? 0
                let newUnderline = currentUnderline == 0 ? NSUnderlineStyle.single.rawValue : 0
                mutableAttrText.addAttribute(.underlineStyle, value: newUnderline, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            let currentUnderline = textView.typingAttributes[.underlineStyle] as? Int ?? 0
            let newUnderline = currentUnderline == 0 ? NSUnderlineStyle.single.rawValue : 0
            textView.typingAttributes[.underlineStyle] = newUnderline
        }
    }

    //MARK: - Strikethrough
    func toggleStrikethrough(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentStrike = attributes[.strikethroughStyle] as? Int ?? 0
                let newStrike = currentStrike == 0 ? NSUnderlineStyle.single.rawValue : 0
                mutableAttrText.addAttribute(.strikethroughStyle, value: newStrike, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            let currentStrike = textView.typingAttributes[.strikethroughStyle] as? Int ?? 0
            let newStrike = currentStrike == 0 ? NSUnderlineStyle.single.rawValue : 0
            textView.typingAttributes[.strikethroughStyle] = newStrike
        }
    }

    //MARK: - Superscript
    func toggleSuperscript(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentOffset = attributes[.baselineOffset] as? CGFloat ?? 0
                let newOffset: CGFloat = currentOffset == 0 ? 8 : 0

                mutableAttrText.addAttribute(.baselineOffset, value: newOffset, range: range)
                // Optional: reduce font size for superscript
                let font = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                mutableAttrText.addAttribute(.font, value: font.withSize(font.pointSize * 0.7), range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            // Apply to future typing
            let currentOffset = textView.typingAttributes[.baselineOffset] as? CGFloat ?? 0
            let newOffset: CGFloat = currentOffset == 0 ? 8 : 0
            textView.typingAttributes[.baselineOffset] = newOffset

            let font = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            textView.typingAttributes[.font] = font.withSize(font.pointSize * 0.7)
        }
    }

    //MARK: - Subscript
    func toggleSubscript(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
                let currentOffset = attributes[.baselineOffset] as? CGFloat ?? 0
                let newOffset: CGFloat = currentOffset == 0 ? -4 : 0

                mutableAttrText.addAttribute(.baselineOffset, value: newOffset, range: range)
                let font = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
                mutableAttrText.addAttribute(.font, value: font.withSize(font.pointSize * 0.7), range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            let currentOffset = textView.typingAttributes[.baselineOffset] as? CGFloat ?? 0
            let newOffset: CGFloat = currentOffset == 0 ? -4 : 0
            textView.typingAttributes[.baselineOffset] = newOffset

            let font = textView.typingAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
            textView.typingAttributes[.font] = font.withSize(font.pointSize * 0.7)
        }
    }

    //MARK: - H1 TO H6
    func applyHeading(textView: UITextView, level: Int) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        // Define font sizes for H1–H6
        let fontSize: CGFloat
        switch level {
        case 1: fontSize = 28
        case 2: fontSize = 24
        case 3: fontSize = 20
        case 4: fontSize = 18
        case 5: fontSize = 16
        case 6: fontSize = 14
        default: fontSize = 16
        }

        let headingFont = UIFont.boldSystemFont(ofSize: fontSize)

        if selectedRange.length > 0 {
            // Apply to selected text
            mutableAttrText.addAttribute(.font, value: headingFont, range: selectedRange)
            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            // Apply to future typing
            textView.typingAttributes[.font] = headingFont
        }
    }

    func applyTextColor(textView: UITextView, color: UIColor) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            mutableAttrText.addAttribute(.foregroundColor, value: color, range: selectedRange)
            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            textView.typingAttributes[.foregroundColor] = color
        }
    }
    
    func applyBackgroundColor(textView: UITextView, color: UIColor) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        if selectedRange.length > 0 {
            // ✅ Apply background color to selected text
            mutableAttrText.addAttribute(.backgroundColor, value: color, range: selectedRange)
            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange
        } else {
            // ✅ Apply to future typed text
            textView.typingAttributes[.backgroundColor] = color
        }
    }

    
    func showColorPicker(mode: ColorApplyMode) {
        colorApplyMode = mode
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    //MARK: - increaseIndent
    func increaseIndent(textView: UITextView) {
        let selectedRange = textView.selectedRange

        if selectedRange.length > 0 {
            // ✅ Apply to selected text
            let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
            let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)

            mutableAttrText.enumerateAttributes(in: paragraphRange, options: []) { attributes, range, _ in
                let paragraphStyle = (attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
                paragraphStyle.headIndent += 20
                paragraphStyle.firstLineHeadIndent += 20

                mutableAttrText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            // ✅ Apply to future typing (no selection)
            let currentStyle = (textView.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
            currentStyle.headIndent += 20
            currentStyle.firstLineHeadIndent += 20
            textView.typingAttributes[.paragraphStyle] = currentStyle
        }
    }

    //MARK: - DecreaseIndent
    func decreaseIndent(textView: UITextView) {
        let selectedRange = textView.selectedRange

        if selectedRange.length > 0 {
            // ✅ Apply to selected text
            let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
            let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)

            mutableAttrText.enumerateAttributes(in: paragraphRange, options: []) { attributes, range, _ in
                let paragraphStyle = (attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()

                // Prevent negative indent
                paragraphStyle.headIndent = max(0, paragraphStyle.headIndent - 20)
                paragraphStyle.firstLineHeadIndent = max(0, paragraphStyle.firstLineHeadIndent - 20)

                mutableAttrText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            }

            textView.attributedText = mutableAttrText
            textView.selectedRange = selectedRange

        } else {
            // ✅ Apply to future typing
            let currentStyle = (textView.typingAttributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()

            currentStyle.headIndent = max(0, currentStyle.headIndent - 20)
            currentStyle.firstLineHeadIndent = max(0, currentStyle.firstLineHeadIndent - 20)

            textView.typingAttributes[.paragraphStyle] = currentStyle
        }
    }
    
    //MARK: - Align,left,Right
    func applyTextAlignment(textView: UITextView, alignment: TextAlignmentType) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)

        // If no selection, apply to current paragraph
        let targetRange = selectedRange.length > 0
            ? selectedRange
            : (textView.text as NSString).paragraphRange(for: selectedRange)

        mutableAttrText.enumerateAttributes(in: targetRange, options: []) { attributes, range, _ in
            let paragraphStyle = (attributes[.paragraphStyle] as? NSMutableParagraphStyle)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()

            switch alignment {
            case .left:
                paragraphStyle.alignment = .left
            case .center:
                paragraphStyle.alignment = .center
            case .right:
                paragraphStyle.alignment = .right
            }

            mutableAttrText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }

        // Update the textView
        textView.attributedText = mutableAttrText
        textView.selectedRange = selectedRange

        // Also update future typing
        let paragraphStyle = NSMutableParagraphStyle()
        switch alignment {
        case .left:
            paragraphStyle.alignment = .left
        case .center:
            paragraphStyle.alignment = .center
        case .right:
            paragraphStyle.alignment = .right
        }
        textView.typingAttributes[.paragraphStyle] = paragraphStyle
    }

    
    
//    MARK: - bulletList
    func toggleBulletList(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
        let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)
        let fullText = mutableAttrText.string as NSString
        let lines = fullText.substring(with: paragraphRange).components(separatedBy: "\n")

        var resultText = ""

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.hasPrefix("• ") {
                // ✅ Remove bullet
                resultText += line.replacingOccurrences(of: "• ", with: "") + "\n"
            } else if let range = trimmed.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                // ✅ Remove number and add bullet
                let newLine = trimmed.replacingCharacters(in: range, with: "• ")
                resultText += newLine + "\n"
            } else {
                // ✅ Add bullet
                resultText += "• \(line)\n"
            }
        }

        mutableAttrText.replaceCharacters(in: paragraphRange, with: resultText.trimmingCharacters(in: .newlines))
        textView.attributedText = mutableAttrText
        textView.selectedRange = NSRange(location: paragraphRange.location, length: 0)
    }


    func toggleNumberedList(textView: UITextView) {
        let selectedRange = textView.selectedRange
        let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
        let paragraphRange = (textView.text as NSString).paragraphRange(for: selectedRange)
        let fullText = mutableAttrText.string as NSString
        let lines = fullText.substring(with: paragraphRange).components(separatedBy: "\n")

        var resultText = ""
        let isNumbered = lines.first?.trimmingCharacters(in: .whitespaces).range(of: #"^\d+\.\s"#, options: .regularExpression) != nil

        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if isNumbered {
                // ✅ Remove number
                let newLine = trimmed.replacingOccurrences(of: #"^\d+\.\s"#, with: "", options: .regularExpression)
                resultText += newLine + "\n"
            } else if trimmed.hasPrefix("• ") {
                // ✅ Remove bullet and add number
                let withoutBullet = trimmed.replacingOccurrences(of: "• ", with: "")
                resultText += "\(index + 1). \(withoutBullet)\n"
            } else {
                // ✅ Add number
                resultText += "\(index + 1). \(line)\n"
            }
        }

        mutableAttrText.replaceCharacters(in: paragraphRange, with: resultText.trimmingCharacters(in: .newlines))
        textView.attributedText = mutableAttrText
        textView.selectedRange = NSRange(location: paragraphRange.location, length: 0)
    }


    
}


extension General_InfoVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        applyColor(selectedColor: viewController.selectedColor)
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // Live preview
        applyColor(selectedColor: viewController.selectedColor)
    }

    func applyColor(selectedColor: UIColor) {
        switch colorApplyMode {
        case .text:
            applyTextColor(textView: txt_Aboutus, color: selectedColor)
        case .background:
            applyBackgroundColor(textView: txt_Aboutus, color: selectedColor)
        }
    }
}


