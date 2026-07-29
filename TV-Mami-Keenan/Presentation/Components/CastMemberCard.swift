import SwiftUI

struct CastMemberCard: View {

    let member: CastMember

    private enum Layout {
        static let photoSize: CGFloat = 72
        static let cardWidth: CGFloat = 88
        static let cornerRadius: CGFloat = 36
    }

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: member.person.photoURL) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(Color(.systemGray5))
                        .overlay { ProgressView().scaleEffect(0.6) }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                case .failure:
                    Circle()
                        .fill(Color(.systemGray5))
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    Circle().fill(Color(.systemGray5))
                }
            }
            .frame(width: Layout.photoSize, height: Layout.photoSize)
            .clipShape(Circle())

            VStack(spacing: 2) {
                Text(member.person.name)
                    .font(.caption.bold())
                    .multilineTextAlignment(.center)
                    .lineLimit(1)

                Text(member.character.name)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
        }
        .frame(width: Layout.cardWidth)
    }
}