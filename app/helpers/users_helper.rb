module UsersHelper

  def avatar(user)
    if user.avatar.file.nil?
      image_tag('avatar.png', alt: user.name, class: 'avatar', size: '100')
    else
      image_tag(user.avatar, alt: user.name, class: 'avatar', size: '100')
    end
  end
end
